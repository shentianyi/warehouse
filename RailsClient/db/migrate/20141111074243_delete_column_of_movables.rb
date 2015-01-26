class DeleteColumnOfMovables < ActiveRecord::Migration
  def change
    remove_column :location_containers,:sender_id,:string
    remove_column :location_containers,:receiver_id,:string
    remove_column :location_containers,:delivery_date,:datetime
    remove_column :location_containers,:received_date,:datetime
  end
end
