class ChangeCloumnsToPickOrder < ActiveRecord::Migration
  def change
    change_column :pick_orders, :order_id, :string
    change_column :pick_orders, :pick_list_id, :string
  end
end
