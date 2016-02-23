json.array!(@whouses) do |whouse|
  json.extract! whouse, :nr
  json.url whouse_url(whouse, format: :json)
end
