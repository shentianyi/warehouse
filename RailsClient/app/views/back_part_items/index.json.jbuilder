json.array!(@back_part_items) do |back_part_item|
  json.extract! back_part_item, :id, :back_part_id, :part_id, :qty, :back_reason, :has_sample, :remark, :whouse_id, :position_id
  json.url back_part_item_url(back_part_item, format: :json)
end
