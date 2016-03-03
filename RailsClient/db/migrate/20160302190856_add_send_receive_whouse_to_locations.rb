class AddSendReceiveWhouseToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :send_whouse_id, :string
    add_column :locations, :receive_whouse_id, :string
  end
end
