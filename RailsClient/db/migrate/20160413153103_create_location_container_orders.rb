class CreateLocationContainerOrders < ActiveRecord::Migration
  def change
    create_table :location_container_orders do |t|
      t.string :location_container_id
      t.string :order_id

      t.timestamps
    end
  end
end
