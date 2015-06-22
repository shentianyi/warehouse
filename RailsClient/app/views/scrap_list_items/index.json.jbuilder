json.array!(@scrap_list_items) do |scrap_list_item|
  json.extract! scrap_list_item, :id, :scrap_list_id, :part_id
  json.url scrap_list_item_url(scrap_list_item, format: :json)
end
