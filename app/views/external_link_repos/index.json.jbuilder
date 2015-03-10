json.array!(@external_link_repos) do |external_link_repo|
  json.extract! external_link_repo, :id, :external_link_id, :repo_id
  json.url external_link_repo_url(external_link_repo, format: :json)
end
