json.array!(@repos) do |repo|
  json.extract! repo, :id, :url, :github_identifier, :hook
  json.url repo_url(repo, format: :json)
end
