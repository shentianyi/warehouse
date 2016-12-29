class AddCarIdToLed < ActiveRecord::Migration
  def change
    add_column :leds, :order_car_id, :integer
  end
end
