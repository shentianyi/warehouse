json.array!(@part_types) do |part_type|
  json.extract! part_type, :id, :name
  json.url part_type_url(part_type, format: :json)
end
