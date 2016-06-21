json.array!(@wrappage_movements) do |wrappage_movement|
  json.extract! wrappage_movement, :id, :move_date, :package_type_id, :user_id
  json.url wrappage_movement_url(wrappage_movement, format: :json)
end
