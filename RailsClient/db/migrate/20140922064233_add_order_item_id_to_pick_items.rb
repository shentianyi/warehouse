class AddOrderItemIdToPickItems < ActiveRecord::Migration
  def change
    add_column :pick_items, :order_item_id, :string
    add_index :pick_items, :order_item_id
  end
end
