json.array!(@commits) do |commit|
  json.extract! commit, :id, :data, :sha, :patch_identifier, :message, :author_github_user_id, :author_date, :committer_github_user_id, :committer_date
  json.url commit_url(commit, format: :json)
end
