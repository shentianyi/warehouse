json.array!(@part_clients) do |part_client|
  json.extract! part_client, :id, :parts_id, :client_part_nr, :client_tenant_id
  json.url part_client_url(part_client, format: :json)
end
