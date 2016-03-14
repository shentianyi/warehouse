class Permission < ActiveRecord::Base
  has_many :permission_group_items, dependent: :destroy

  validates_presence_of :name, :message => "权限名称不能为空!"
  validates_uniqueness_of :name, :message => "权限名称不能重复!"
end
