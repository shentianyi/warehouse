json.array!(@wrappages) do |wrappage|
  json.extract! wrappage, :id, :nr, :name, :desc
  json.url wrappage_url(wrappage, format: :json)
end
