class PermissionGroup < ActiveRecord::Base
  has_many :user_permission_groups, dependent: :destroy
  has_many :permission_group_items, dependent: :destroy
  has_many :permissions, through: :permission_group_items
end
