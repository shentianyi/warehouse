json.array!(@user_permission_groups) do |user_permission_group|
  json.extract! user_permission_group, :id, :user_id, :permission_group_id
  json.url user_permission_group_url(user_permission_group, format: :json)
end
