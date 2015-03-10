json.array!(@external_link_commits) do |external_link_commit|
  json.extract! external_link_commit, :id, :external_link_id, :commit_id
  json.url elc_url(external_link_commit, format: :json)
end
