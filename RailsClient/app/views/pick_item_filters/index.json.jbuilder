json.array!(@pick_item_filters) do |pick_item_filter|
  json.extract! pick_item_filter, :id, :id, :user_id, :value, :filterable_id, :filterable_type
  json.url pick_item_filter_url(pick_item_filter, format: :json)
end
