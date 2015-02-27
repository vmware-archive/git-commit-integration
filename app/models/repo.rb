class Repo < ActiveRecord::Base
  def create_hook(current_user, request_original_url)

    token = current_user.github_app_token
    raise 'App must be authorized first...' unless token
    matches = /github.com(\/|:)(.+)\/(.+).git/.match(url)
    github_user = matches[2]
    github_repo = matches[3]

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

    github = Github.new(oauth_token: token)
    response = nil
    begin
      response = do_create(github, github_user, github_repo, hook_config)
    rescue Github::Error::UnprocessableEntity => e
      p "Error creating hook: #{e.inspect}.  Attempting to delete and recreate web hook for #{webhook_url}"
      existing_hook_id = github.repos.hooks.list(github_user, github_repo).detect{|h| h.config.url == webhook_url}.id
      github.repos.hooks.delete(github_user, github_repo, existing_hook_id)
      response = do_create(github, github_user, github_repo, hook_config)
    end
    update_attributes!(hook: response.to_hash.to_json)
  end

  def do_create(github, github_user, github_repo, hook_config)
    github.repos.hooks.create(github_user, github_repo, {name: 'web', active: false, events: ['push'], config: hook_config})
  end
end
