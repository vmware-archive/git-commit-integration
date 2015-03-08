class PatchIdGenerator
  include ProcessHelper

  def generate(github_user, github_repo, sha)
    # TODO: Don't know how to use the github api gem to get the raw patch text,
    #       so just using direct faraday.  See https://github.com/peter-murach/github/issues/220

    curl_cmd = "curl -H \"Accept: application/vnd.github.v3.patch\" -s https://api.github.com/repos/#{github_user}/#{github_repo}/commits/#{sha}"

    conn = Faraday.new(:url => 'https://api.github.com') do |faraday|
      faraday.response :logger # log requests to STDOUT
      faraday.adapter Faraday.default_adapter # make requests with Net::HTTP
    end

    response = conn.get do |req|
      req.url "/repos/#{github_user}/#{github_repo}/commits/#{sha}"
      req.headers['Accept'] = 'application/vnd.github.v3.patch'
    end

    patch_text = response.body
    unless patch_text =~ /^From [0-9a-f]+ /
      raise "Invalid patch_text retrieved.  " \
          "Run curl command and verify it: `#{curl_cmd}`.  Patch text:\n\n#{patch_text}"
    end

    patch_identifier_text = process("echo '#{patch_text}' | git patch-id --stable")

    unless patch_identifier_text =~ /^[0-9a-f]+ #{sha}$/
      raise "Invalid patch_identifier retrieved.  " \
          "Run curl command and pipe to 'git patch-id --stable' verify it: `#{curl_cmd} | git patch-id --stable`"
    end

    patch_identifier_text.split(' ').first
  end
end
