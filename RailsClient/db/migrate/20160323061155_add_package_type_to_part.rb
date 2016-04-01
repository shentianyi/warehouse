class AddPackageTypeToPart < ActiveRecord::Migration
  def change
    add_column :parts, :package_type_id, :integer
  end
end
