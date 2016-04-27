json.array!(@back_parts) do |back_part|
  json.extract! back_part, :id, :builder, :des_location_id, :src_location_id
  json.url back_part_url(back_part, format: :json)
end
