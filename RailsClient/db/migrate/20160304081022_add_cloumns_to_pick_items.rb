class AddCloumnsToPickItems < ActiveRecord::Migration
  def change
    add_column :pick_items, :position_id, :string
    add_column :pick_items, :weight, :float
    add_column :pick_items, :weight_qty, :float
    add_column :pick_items, :weight_valid, :boolean
    add_index :pick_items, [:position_id, :weight_valid]
  end
end
