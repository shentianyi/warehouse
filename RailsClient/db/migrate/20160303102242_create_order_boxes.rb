class CreateOrderBoxes < ActiveRecord::Migration
  def change
    create_table :order_boxes do |t|
      t.string :nr
      t.string :rfid_nr
      t.integer :status, default: 100
      t.references :part, index: true
      t.float :quantity
      t.references :order_box_type, index: true
      t.references :warehouse, index: true
      t.references :source_warehouse, index: true

      t.timestamps
    end
  end
end
