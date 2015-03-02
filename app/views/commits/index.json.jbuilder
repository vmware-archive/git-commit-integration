json.array!(@commits) do |commit|
  json.extract! commit, :id, :data, :sha, :patch_id, :message, :author_github_user_id, :author_date, :committer_github_user_id, :committer_date, :push_id
  json.url commit_url(commit, format: :json)
end
