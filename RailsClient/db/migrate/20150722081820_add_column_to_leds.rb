class AddColumnToLeds < ActiveRecord::Migration
  def change
    add_column :leds, :led_display, :string
  end
end
