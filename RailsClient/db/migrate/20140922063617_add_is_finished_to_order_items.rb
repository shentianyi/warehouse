class AddIsFinishedToOrderItems < ActiveRecord::Migration
  def change
    add_column :order_items, :is_finished, :boolean, :default => false
  end
end
