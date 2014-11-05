class AddDestinationIdToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :destination_id,:string
    remove_column :locations, :location_type

#     reversible do |dir|
#       dir.up do
#         execute <<-SQL
#         ALTER TABLE locations
# ADD CONSTRAINT fk_locations_destinations
# FOREIGN KEY (destination_id)
# REFERENCES locations(id)
#         SQL
#       end
#
#       dir.down do
#         execute <<-SQL
#         ALTER TABLE locations
# DROP FOREIGN KEY fk_locations_destinations
#         SQL
#       end
#     end

    add_index :locations, :destination_id
  end
end
