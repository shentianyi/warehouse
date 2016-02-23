class CreatePermissionGroupItems < ActiveRecord::Migration
  def change
    create_table :permission_group_items do |t|
      t.references :permission, index: true
      t.references :permission_group, index: true

      t.timestamps
    end
  end
end
