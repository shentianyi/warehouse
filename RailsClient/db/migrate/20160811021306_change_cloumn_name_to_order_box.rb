class ChangeCloumnNameToOrderBox < ActiveRecord::Migration
  def change
    rename_column :order_boxes, :warehouse_id, :whouse_id
    rename_column :order_boxes, :source_warehouse_id, :source_whouse_id
  end
end
