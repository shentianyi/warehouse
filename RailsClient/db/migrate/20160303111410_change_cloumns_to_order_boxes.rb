class ChangeCloumnsToOrderBoxes < ActiveRecord::Migration
  def change
    add_column :order_boxes, :position_id, :string
    add_index :order_boxes,:position_id
    change_column :order_boxes, :part_id, :string
    change_column :order_boxes, :warehouse_id, :string
    change_column :order_boxes, :source_warehouse_id, :string
  end
end
