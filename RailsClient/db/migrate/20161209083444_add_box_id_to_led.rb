class AddBoxIdToLed < ActiveRecord::Migration
  def change
    add_column :leds, :order_box_id, :integer
  end
end
