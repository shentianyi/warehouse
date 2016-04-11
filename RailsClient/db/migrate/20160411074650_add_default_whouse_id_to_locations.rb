class AddDefaultWhouseIdToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :default_whouse_id, :string
  end
end
