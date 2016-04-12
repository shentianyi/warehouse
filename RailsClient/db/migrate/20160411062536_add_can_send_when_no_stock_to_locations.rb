class AddCanSendWhenNoStockToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :can_send_when_no_stock, :boolean,default: false
  end
end
