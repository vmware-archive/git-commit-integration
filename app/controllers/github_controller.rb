class GithubController < ApplicationController

  def authorize
    scopes = 'user,repo,public_repo'
    if Rails.env.development?
      address = app_github.authorize_url redirect_uri: 'http://localhost:3000/users/auth/github/callback/auth_app_callback', scope: scopes
    else
      address = app_github.authorize_url redirect_uri: users_auth_github_callback_auth_app_callback_path, scope: scopes
    end
    redirect_to address
  end

  def auth_app_callback
    authorization_code = params[:code]
    access_token = app_github.get_token authorization_code
    token = access_token.token
    current_user.update_attributes!(github_app_token: token)
    redirect_to root_path
  end

  private

  def app_github
    @github ||= Github.new client_id: ENV.fetch('GITHUB_KEY'), client_secret: ENV.fetch('GITHUB_SECRET')
  end
end
