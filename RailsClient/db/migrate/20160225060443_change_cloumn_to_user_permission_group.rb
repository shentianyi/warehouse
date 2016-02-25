class ChangeCloumnToUserPermissionGroup < ActiveRecord::Migration
  def change
    change_column :user_permission_groups, :user_id, :string
  end
end
