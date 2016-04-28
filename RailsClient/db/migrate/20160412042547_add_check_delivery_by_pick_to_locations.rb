class AddCheckDeliveryByPickToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :check_delivery_by_pick, :boolean,default: false
  end
end
