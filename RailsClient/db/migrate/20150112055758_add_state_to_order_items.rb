class AddStateToOrderItems < ActiveRecord::Migration
  def change
    add_column :order_items,:state,:integer,:default => 0
    add_column :orders,:source_location_id,:string
  end
end
