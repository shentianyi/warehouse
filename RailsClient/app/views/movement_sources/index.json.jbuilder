json.array!(@movement_sources) do |movement_source|
  json.extract! movement_source, :id, :movement_list_id, :fromWh, :fromPosition, :packageId, :partNr, :qty, :fifo, :toWh, :toPosition, :employee_id, :remarks
  json.url movement_source_url(movement_source, format: :json)
end
