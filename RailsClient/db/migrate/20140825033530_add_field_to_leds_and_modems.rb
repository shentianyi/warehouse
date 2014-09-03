class AddFieldToLedsAndModems < ActiveRecord::Migration
  def change
    add_column :leds ,:mac,:string
    #add_column :leds ,:pan_id,:string
  end
end
