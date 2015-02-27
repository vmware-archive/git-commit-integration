json.array!(@pushes) do |push|
  json.extract! push, :id, :payload, :ref, :head_commit
  json.url push_url(push, format: :json)
end
