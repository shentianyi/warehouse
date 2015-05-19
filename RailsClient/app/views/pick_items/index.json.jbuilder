json.array!(@pick_items) do |pick_item|
  json.extract! pick_item, :id, :id, :pick_list_id, :order_item_id
  json.url pick_item_url(pick_item, format: :json)
end
