class AddSourceIdToOrders < ActiveRecord::Migration
  def change
  	add_column :orders,:source_id, :string
  	add_index :orders, :source_id
  end
end
