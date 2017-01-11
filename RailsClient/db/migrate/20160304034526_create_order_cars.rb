class CreateOrderCars < ActiveRecord::Migration
  def change
    create_table :order_cars do |t|
      t.string :nr
      t.string :rfid_nr
      t.integer :status, default: 100
      t.references :whouse, index: true

      t.timestamps
    end
  end
end
