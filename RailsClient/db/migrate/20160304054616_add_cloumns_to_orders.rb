class AddCloumnsToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :orderable_id, :integer
    add_column :orders, :orderable_type, :string
    add_column :orders, :whouse_id, :string
    add_index :orders, [:whouse_id, :orderable_type, :orderable_id]
  end
end
