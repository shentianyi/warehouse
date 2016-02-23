class AddTenantIdToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :tenant_id, :integer
    add_index :locations, :tenant_id
  end
end
