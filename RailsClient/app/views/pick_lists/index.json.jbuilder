json.array!(@pick_lists) do |pick_list|
  json.extract! pick_list, :id, :id, :user_id
  json.url pick_list_url(pick_list, format: :json)
end
