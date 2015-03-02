json.array!(@github_users) do |github_user|
  json.extract! github_user, :id, :username, :email
  json.url github_user_url(github_user, format: :json)
end
