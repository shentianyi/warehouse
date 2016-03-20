class PermissionGroup < ActiveRecord::Base
  has_many :user_permission_groups, dependent: :destroy
  has_many :permission_group_items, dependent: :destroy
  has_many :permissions, through: :permission_group_items


  def manage_permissions ids
    deletes=self.permission_group_items.pluck(:permission_id) - ids
    deletes.each do |d|
      PermissionGroupItem.where(permission_group_id: self.id, permission_id: d).first.destroy
    end

    creates=ids - self.permission_group_items.pluck(:permission_id)
    creates.each do |c|
      pi=PermissionGroupItem.new({permission_group_id: self.id, permission_id: c})
      if pi.save
        self.permission_group_items<<pi
      end
    end
  end

  def permission_details
    data=[]

    permissions=self.permissions
    Permission.all.each do |p|
      data<<{
          id: p.id,
          name: p.name,
          description: p.description,
          status: permissions.include?(p)
      }
    end
    data
  end
end
