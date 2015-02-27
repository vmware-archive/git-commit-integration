class MissingGithubAppTokenError < RuntimeError
  def message
    'App must be authorized first...'
  end
end
