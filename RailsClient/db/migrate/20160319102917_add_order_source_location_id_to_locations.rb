class AddOrderSourceLocationIdToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :order_source_location_id, :string
  end
end
