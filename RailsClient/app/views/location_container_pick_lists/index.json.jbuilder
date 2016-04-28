json.array!(@location_container_pick_lists) do |location_container_pick_list|
  json.extract! location_container_pick_list, :id, :location_container_id, :pick_list_id
  json.url location_container_pick_list_url(location_container_pick_list, format: :json)
end
