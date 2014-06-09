json.array!(@whouses) do |whouse|
  json.extract! whouse, :id
  json.url whouse_url(whouse, format: :json)
end
