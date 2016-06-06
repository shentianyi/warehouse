json.array!(@wrappage_movement_items) do |wrappage_movement_item|
  json.extract! wrappage_movement_item, :id, :src_location_id, :des_location_id, :qty, :wrappage_move_type, :user_id, :sourceable_id, :sourceable_type, :extra_800_nos, :extra_leoni_out_no
  json.url wrappage_movement_item_url(wrappage_movement_item, format: :json)
end
