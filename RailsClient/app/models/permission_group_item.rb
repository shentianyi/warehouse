class PermissionGroupItem < ActiveRecord::Base
  belongs_to :permission
  belongs_to :permission_group
end
