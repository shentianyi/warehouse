json.array!(@location_container_orders) do |location_container_order|
  json.extract! location_container_order, :id, :location_container_id, :order_id
  json.url location_container_order_url(location_container_order, format: :json)
end
