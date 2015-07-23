class AddIsValidToLeds < ActiveRecord::Migration
  def change
    add_column :leds, :is_valid, :boolean
  end
end
