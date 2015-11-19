json.array!(@storage_operation_records) do |storage_operation_record|
  json.extract! storage_operation_record, :id, :partNr, :qty, :fromWh, :fromPosition, :toWh, :toPosition, :packageId, :type_id, :remarks, :employee_id
  json.url storage_operation_record_url(storage_operation_record, format: :json)
end
