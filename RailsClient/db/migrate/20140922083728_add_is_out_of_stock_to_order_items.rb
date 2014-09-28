class AddIsOutOfStockToOrderItems < ActiveRecord::Migration
  def change
    add_column :order_items, :out_of_stock, :boolean, :default => false
  end
end
