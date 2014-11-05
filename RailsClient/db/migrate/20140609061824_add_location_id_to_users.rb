class AddLocationIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :location_id, :string

#     reversible do |dir|
#       dir.up do
#         execute <<-SQL
#       ALTER TABLE users
# ADD CONSTRAINT fk_users_locations
# FOREIGN KEY (location_id)
# REFERENCES locations(id)
#         SQL
#       end
#
#       dir.down do
#         execute <<-SQL
#         ALTER TABLE users
# DROP FOREIGN KEY fk_users_locations
#         SQL
#       end
#     end

    add_index :users, :location_id
  end
end
