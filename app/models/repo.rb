class Repo < ActiveRecord::Base
  include GithubApiFactory

  has_many :pushes
  validates_presence_of :github_identifier

  before_validation :set_github_identifier

  attr_accessor :current_user # TODO: may need this if we ever need it in a separate thread: http://stackoverflow.com/questions/20881172/how-to-get-devises-current-user-in-activerecord-callback-in-rails

  def create_hook(request_original_url)
    github = create_github_api_from_oauth_token(current_user)
    github_user, github_repo = user_and_repo

    req_uri = URI.parse(request_original_url)
    if Rails.env.development?
      host_port = ENV.fetch('NGROK_HOST')
    else
      host_port = "#{req_uri.host}:#{req_uri.port}"
    end
    webhook_url = "#{req_uri.scheme}://#{host_port}/pushes/receive"

    hook_config = {
      content_type: 'json',
      insecure_ssl: 1,
      url: webhook_url
    }

    response = nil
    begin
      response = do_create_hook(github, hook_config)
    rescue Github::Error::UnprocessableEntity => e
      p "Error creating hook: #{e.inspect}.  Attempting to delete and recreate web hook for #{webhook_url}"
      existing_hook_id = github.repos.hooks.list(github_user, github_repo).detect{|h| h.config.url == webhook_url}.id
      github.repos.hooks.delete(github_user, github_repo, existing_hook_id)
      response = do_create_hook(github, hook_config)
    end
    update_attributes!(hook: response.to_hash.to_json)
  end

  def github_api_object
    github = create_github_api_from_oauth_token(current_user)
    github_user, github_repo = user_and_repo
    github.repos.get(github_user, github_repo)
  end

  def user_and_repo
    matches = /github.com(\/|:)(.+)\/(.+).git/.match(url)
    github_user = matches[2]
    github_repo = matches[3]
    return github_user, github_repo
  end

  private

  def do_create_hook(github, hook_config)
    github_user, github_repo = user_and_repo
    github.repos.hooks.create(github_user, github_repo, {name: 'web', active: false, events: ['push'], config: hook_config})
  end

  def set_github_identifier
    return true if github_identifier.present?
    self.github_identifier = github_api_object.id
  end
end
