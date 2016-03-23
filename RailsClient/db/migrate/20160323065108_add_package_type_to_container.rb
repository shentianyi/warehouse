class AddPackageTypeToContainer < ActiveRecord::Migration
  def change
    add_column :containers, :extra_wooden_count, :integer, default: 0
    add_column :containers, :extra_box_count, :integer, default: 0
    add_column :containers, :extra_nps_count, :integer, default: 0
  end
end
