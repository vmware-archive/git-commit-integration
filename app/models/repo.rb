class Repo < ActiveRecord::Base
  include GithubApiFactory
  include OrderedCommits

  has_many :pushes, dependent: :restrict_with_exception
  has_many :refs, dependent: :restrict_with_exception
  has_many :unordered_commits, class_name: 'Commit', dependent: :restrict_with_exception
  has_many :external_link_repos
  has_many :external_links, through: :external_link_repos
  has_many :deploys, through: :deploy_repos
  has_many :deploy_repos
  belongs_to :user

  validates_presence_of :github_identifier
  validates_presence_of :user_id

  before_validation :set_github_identifier

  def create_hook(request_original_url)
    github = create_github_api_from_oauth_token(self)
    github_user, github_repo = user_and_repo

    begin
      github.repos.hooks.list(github_user, github_repo)
    rescue Github::Error::NotFound => e
      raise CannotAccessWebhooksError.new(
          "[gci] #{DateTime.now.utc.iso8601} Cannot access github webhooks for repo " \
            "#{github_user}/#{github_repo}.  Ensure user is an owner of the github repo."
        )
    end

    req_uri = URI.parse(request_original_url)
    if Rails.env.development?
      host_port = ENV.fetch('NGROK_HOST')
    else
      host_port = "#{req_uri.host}:#{req_uri.port}"
    end
    webhook_url = "#{req_uri.scheme}://#{host_port}/repos/#{self.id}/pushes/receive"

    hook_config = {
      content_type: 'json',
      insecure_ssl: 1,
      url: webhook_url
    }

    response = nil
    begin
      response = do_create_hook(github, hook_config)
    rescue Github::Error::UnprocessableEntity => e
      puts "[gci] #{DateTime.now.utc.iso8601} Error creating hook: #{e.inspect}. " \
        "Attempting to delete and recreate web hook for #{webhook_url}"
      existing_hook_id = github.repos.hooks.list(github_user, github_repo).detect { |h| h.config.url == webhook_url }.id
      github.repos.hooks.delete(github_user, github_repo, existing_hook_id)
      response = do_create_hook(github, hook_config)
    end
    update_attributes!(hook: response.to_hash.to_json)
  end

  def github_api_object
    github = create_github_api_from_oauth_token(self)
    github_user, github_repo = user_and_repo
    github.repos.get(github_user, github_repo)
  end

  def user_and_repo
    matches = /github.com(\/|:)(.+)\/(.+).git/.match(url)
    github_user = matches[2]
    github_repo = matches[3]
    return github_user, github_repo
  end

  def commit_link(sha)
    user, repo = user_and_repo
    "https://github.com/#{user}/#{repo}/commit/#{sha}"
  end

  private

  def do_create_hook(github, hook_config)
    github_user, github_repo = user_and_repo
    github.repos.hooks.create(github_user, github_repo, {name: 'web', active: true, events: ['push'], config: hook_config})
  end

  def set_github_identifier
    return true if github_identifier.present?
    self.github_identifier = github_api_object.id
  end
end
