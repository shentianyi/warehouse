class AddFieldsToInventoryListItems < ActiveRecord::Migration
  def change
    add_column :inventory_list_items, :whouse_id, :string
    add_column :inventory_list_items, :fifo, :datetime
    add_column :inventory_list_items, :part_wire_mark, :string
    add_column :inventory_list_items, :part_form_mark, :string
    add_column :inventory_list_items, :origin_qty, :decimal, precision: 20, scale: 10
    add_column :inventory_list_items, :need_convert, :boolean,default: false
  end
end
