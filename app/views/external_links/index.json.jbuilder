json.array!(@external_links) do |external_link|
  json.extract! external_link, :id, :description, :extract_pattern, :uri_template, :replace_pattern, :commits_processed_thru
  json.url external_link_url(external_link, format: :json)
end
