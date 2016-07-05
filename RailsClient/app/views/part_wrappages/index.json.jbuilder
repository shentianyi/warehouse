json.array!(@part_wrappages) do |part_wrappage|
  json.extract! part_wrappage, :id, :part_id, :wrappage_id, :capacity
  json.url part_wrappage_url(part_wrappage, format: :json)
end
