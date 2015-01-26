json.array!(@regex_categories) do |regex_category|
  json.extract! regex_category, :id, :name, :desc, :type
  json.url regex_category_url(regex_category, format: :json)
end
