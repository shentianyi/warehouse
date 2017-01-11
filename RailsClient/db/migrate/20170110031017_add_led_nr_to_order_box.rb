class AddLedNrToOrderBox < ActiveRecord::Migration
  def change
    add_column :order_boxes, :led_id, :string
  end
end
