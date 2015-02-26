json.array!(@repos) do |repo|
  json.extract! repo, :id, :url, :hook
  json.url repo_url(repo, format: :json)
end
