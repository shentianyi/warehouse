class UserPermissionGroup < ActiveRecord::Base
  belongs_to :user
  belongs_to :permission_group
end
