class CreateUserPermissionGroups < ActiveRecord::Migration
  def change
    create_table :user_permission_groups do |t|
      t.references :user, index: true
      t.references :permission_group, index: true

      t.timestamps
    end
  end
end
