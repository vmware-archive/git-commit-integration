json.array!(@deploy_repos) do |deploy_repo|
  json.extract! deploy_repo, :id, :deploy_id, :repo_id
  json.url deploy_repo_url(deploy_repo, format: :json)
end
