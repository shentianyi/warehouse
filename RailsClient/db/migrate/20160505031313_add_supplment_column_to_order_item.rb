class AddSupplmentColumnToOrderItem < ActiveRecord::Migration
  def change
    add_column :order_items, :is_supplment, :boolean
  end
end
