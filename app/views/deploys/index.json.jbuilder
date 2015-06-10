json.array!(@deploys) do |deploy|
  json.extract! deploy, :id, :name, :uri, :extract_pattern
  json.url deploy_url(deploy, format: :json)
end
