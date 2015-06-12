json.array!(@scrap_lists) do |scrap_list|
  json.extract! scrap_list, :id, :src_warehouse, :dse_warehouse, :builder
  json.url scrap_list_url(scrap_list, format: :json)
end
