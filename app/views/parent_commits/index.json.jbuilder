json.array!(@parent_commits) do |parent_commit|
  json.extract! parent_commit, :id, :commit_id, :sha
  json.url parent_commit_url(parent_commit, format: :json)
end
