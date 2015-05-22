class PatchTooLongError < RuntimeError

end

class PatchIdGenerator
  include ProcessHelper

  def generate(github_user, github_repo, sha, github_app_token = nil)
    # TODO: Don't know how to use the github api gem to get the raw patch text,
    #       so just using direct faraday.  See https://github.com/peter-murach/github/issues/220

    curl_cmd = "curl -H \"Authorization: token OPTIONAL_GITHUB_APP_TOKEN\" " \
     "-H \"Accept: application/vnd.github.v3.patch\" " \
     "-s https://api.github.com/repos/#{github_user}/#{github_repo}/commits/#{sha}"

    conn = Faraday.new(:url => 'https://api.github.com') do |faraday|
      faraday.response :logger # log requests to STDOUT
      faraday.adapter Faraday.default_adapter # make requests with Net::HTTP
    end

    patch_text = nil
    begin
      Timeout.timeout(15) do
        puts "[gci] #{DateTime.now.utc.iso8601} PatchIdGenerator - retrieving patch for repo #{github_repo}, sha #{sha}"
        response = conn.get do |req|
          req.url "/repos/#{github_user}/#{github_repo}/commits/#{sha}"
          req.headers['Authorization'] = "token #{github_app_token}" if github_app_token
          req.headers['Accept'] = 'application/vnd.github.v3.patch'
        end

        patch_text = response.body
        unless patch_text =~ /^From [0-9a-f]+ /
          raise "[gci] #{DateTime.now.utc.iso8601} Invalid patch_text retrieved.  " \
          "Run curl command and verify it: `#{curl_cmd}`.  Patch text:\n\n#{patch_text}"
        end
      end
    rescue TimeoutError => e
      puts "[gci] #{DateTime.now.utc.iso8601} PatchIdGenerator - timeout while retrieving patch for repo #{github_repo}, sha #{sha}"
      return 'timeout_while_retrieving_patch'
    end

    begin
      raise PatchTooLongError if patch_text.size > 2**20 # hangs on commit 7192e2 in gitrflow repo, 1537939 (or bad/unescapable char?)
      Timeout.timeout(15) do
        puts "[gci] #{DateTime.now.utc.iso8601} PatchIdGenerator - generating patch ID for repo #{github_repo}, sha #{sha}"
        patch_text_escaped = patch_text.gsub("'", '\x27').gsub('%','%%').gsub('\\','\\\\')
        patch_identifier_text = process("printf '#{patch_text_escaped}' | git patch-id --stable")
        # patch_identifier_text = process("git patch-id --stable", in: patch_text.split("\n"))

        unless patch_identifier_text =~ /^[0-9a-f]+ #{sha}$/
          raise "[gci] #{DateTime.now.utc.iso8601} Invalid patch_identifier retrieved.  " \
          "Run curl command and pipe to 'git patch-id --stable' verify it: `#{curl_cmd} | git patch-id --stable`"
        end

        patch_identifier_text.split(' ').first
      end
    rescue TimeoutError => e
      puts "[gci] #{DateTime.now.utc.iso8601} PatchIdGenerator - timeout while generating patch ID for repo #{github_repo}, sha #{sha}"
      'timeout_while_generating_patch_id'
    rescue PatchTooLongError => e
      puts "[gci] #{DateTime.now.utc.iso8601} PatchIdGenerator - patch too long (#{patch_text.size}) for repo #{github_repo}, sha #{sha}"
      "patch_too_long_#{patch_text.size}_chars"
    end
  end
end
