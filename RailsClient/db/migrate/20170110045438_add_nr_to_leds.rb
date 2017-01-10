class AddNrToLeds < ActiveRecord::Migration
  def change
    add_column :leds, :nr, :string
  end
end
