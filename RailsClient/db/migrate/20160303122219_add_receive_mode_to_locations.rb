class AddReceiveModeToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :receive_mode, :integer,default:DeliveryReceiveMode::CUSTOM
  end
end
