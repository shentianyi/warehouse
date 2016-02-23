class Permission < ActiveRecord::Base
  has_many :permission_group_items, dependent: :destroy
end
