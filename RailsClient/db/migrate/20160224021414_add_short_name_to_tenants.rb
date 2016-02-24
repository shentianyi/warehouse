class AddShortNameToTenants < ActiveRecord::Migration
  def change
    add_column :tenants, :short_name, :string
  end
end
