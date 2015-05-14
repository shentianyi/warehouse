class AddParentToLocations < ActiveRecord::Migration
  def change
    add_reference :locations, :parent, index: true
    add_column :locations, :status, :integer, default: 0
    add_column :locations, :remark, :string, default: ''
  end
end
