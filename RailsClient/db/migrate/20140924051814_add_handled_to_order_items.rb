class AddHandledToOrderItems < ActiveRecord::Migration
  def change
    add_column :order_items,:handled, :boolean, :default => false
  end
end
