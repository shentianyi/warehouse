json.array!(@permission_group_items) do |permission_group_item|
  json.extract! permission_group_item, :id, :permission_id, :permission_group_id
  json.url permission_group_item_url(permission_group_item, format: :json)
end
