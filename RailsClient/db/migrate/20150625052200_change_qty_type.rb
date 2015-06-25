class ChangeQtyType< ActiveRecord::Migration
  def change
    change_column :scrap_list_items, :quantity, :decimal, precision: 20, scale: 10
    change_column :inventory_list_items, :qty, :decimal, precision: 20, scale: 10
  end
end
