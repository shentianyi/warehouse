class FixColumnsForPicklistOrders < ActiveRecord::Migration
  def change
    remove_column :pick_lists, :status
    add_column :orders, :status, :integer, :default => 0
  end
end
