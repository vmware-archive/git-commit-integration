class ExternalLinkUriGenerator
  attr_reader :external_link, :commit

  def initialize(external_link, commit)
    @external_link = external_link
    @commit = commit
  end

  def has_match?
    match.present?
  end

  def generate
    unless has_match?
      raise "[gci] #{DateTime.now.utc.iso8601} Unable to generate " \
        "ExternalLink Uri because commit message does not match. " \
        "ExternalLink id #{external_link.id}, " \
        "Commit id #{commit.id}, Commit message: '#{commit.message}'"
    end
    parsed_id = match[1]
    uri = external_link.uri_template.gsub(/#{external_link.replace_pattern}/, parsed_id)
    {
      external_id: parsed_id.to_s,
      external_uri: uri,
    }
  end

  private

  def match
    /#{external_link.extract_pattern}/.match(commit.message)
  end
end
