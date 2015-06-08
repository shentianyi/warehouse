json.array!(@inventory_lists) do |inventory_list|
  json.extract! inventory_list, :id, :name, :state, :whouse_id, :user_id
  json.url inventory_list_url(inventory_list, format: :json)
end
