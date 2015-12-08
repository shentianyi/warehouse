json.array!(@movement_lists) do |movement_list|
  json.extract! movement_list, :id, :builder
  json.url movement_list_url(movement_list, format: :json)
end
