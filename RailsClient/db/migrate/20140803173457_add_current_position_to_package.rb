class AddCurrentPositionToPackage < ActiveRecord::Migration
  def change
    add_column :packages, :positionable_id, :string
    add_column :packages, :positionable_type, :string
    add_index :packages, :positionable_id
    add_index :packages, :positionable_type
  end
end
