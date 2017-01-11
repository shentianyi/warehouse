class AddCloumnsToPartPositions < ActiveRecord::Migration
  def change
    add_column :part_positions, :safe_stock, :float
    add_column :part_positions, :from_warehouse_id, :string
    add_column :part_positions, :from_position_id, :string
  end
end
