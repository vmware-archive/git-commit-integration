module GithubApiFactory
  def create_github_api_from_oauth_token(current_user)
    token = current_user.github_app_token
    raise 'App must be authorized first...' unless token
    Github.new(oauth_token: token)
  end
end
