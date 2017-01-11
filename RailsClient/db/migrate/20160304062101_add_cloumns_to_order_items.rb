class AddCloumnsToOrderItems < ActiveRecord::Migration
  def change
    add_column :order_items, :orderable_id, :integer
    add_column :order_items, :orderable_type, :string
    add_index :order_items, [:orderable_type, :orderable_id]
  end
end
