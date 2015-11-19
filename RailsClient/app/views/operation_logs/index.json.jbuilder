json.array!(@operation_logs) do |operation_log|
  json.extract! operation_log, :id, :item_type, :item_id, :event, :whodunnit, :object
  json.url operation_log_url(operation_log, format: :json)
end
