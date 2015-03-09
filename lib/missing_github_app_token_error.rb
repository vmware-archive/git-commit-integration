class MissingGithubAppTokenError < RuntimeError
  def message
    "[gci] #{DateTime.now.utc.iso8601} App must be authorized first..."
  end
end
