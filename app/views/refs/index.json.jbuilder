json.array!(@refs) do |ref|
  json.extract! ref, :id, :reference, :repo_id
  json.url ref_url(ref, format: :json)
end
