module GithubApiFactory
  def create_github_api_from_oauth_token(repo)
    token = repo.user.github_app_token
    raise MissingGithubAppTokenError.new unless token
    Github.new(oauth_token: token)
  end
end
