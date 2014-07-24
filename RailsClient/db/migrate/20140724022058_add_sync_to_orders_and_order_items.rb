class AddSyncToOrdersAndOrderItems < ActiveRecord::Migration
  def change
  	add_column :orders,:is_delete, :boolean, :default => false
  	add_column :orders,:is_dirty, :boolean, :default => true
  	add_column :orders,:is_new, :boolean, :default => true

  	add_column :order_items,:is_delete, :boolean, :default => false
  	add_column :order_items,:is_dirty, :boolean, :default => true
  	add_column :order_items,:is_new, :boolean, :default => true
  end
end
