json.array!(@pick_orders) do |pick_order|
  json.extract! pick_order, :id, :order_id, :pick_list_id
  json.url pick_order_url(pick_order, format: :json)
end
