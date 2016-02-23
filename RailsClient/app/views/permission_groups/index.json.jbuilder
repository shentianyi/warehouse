json.array!(@permission_groups) do |permission_group|
  json.extract! permission_group, :id, :name, :description
  json.url permission_group_url(permission_group, format: :json)
end
