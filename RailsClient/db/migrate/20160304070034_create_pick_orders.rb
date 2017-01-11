class CreatePickOrders < ActiveRecord::Migration
  def change
    create_table :pick_orders do |t|
      t.references :order, index: true
      t.references :pick_list, index: true

      t.timestamps
    end
  end
end
