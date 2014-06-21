class AddIsBaseToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :is_base, :boolean, :default => false
  end
end
