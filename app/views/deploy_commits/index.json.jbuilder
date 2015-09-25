json.array!(@deploy_commits) do |deploy_commit|
  json.extract! deploy_commit, :id, :deploy_id, :sha
  json.url deploy_commit_url(deploy_commit, format: :json)
end
