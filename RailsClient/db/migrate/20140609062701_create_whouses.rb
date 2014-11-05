class CreateWhouses < ActiveRecord::Migration
  def change
    create_table(:whouses,:id=>false) do |t|
      t.string :uuid, :limit => 36, :null => false
      t.string :id, :limit=>36, :primary=>true, :null=>false
      t.string :name

      t.string :location_id
      #
      t.boolean :is_delete, :default => false
      t.boolean :is_dirty, :default => true
      t.boolean :is_new, :default => true
      #
      t.timestamps
    end
#     reversible do |dir|
#       dir.up do
#         execute <<-SQL
#         ALTER TABLE whouses
# ADD CONSTRAINT fk_whouses_locations
# FOREIGN KEY (location_id)
# REFERENCES locations(id)
#         SQL
#       end
#
#       dir.down do
#         execute <<-SQL
#         ALTER TABLE whouses
# DROP FOREIGN KEY fk_whouses_locations
#         SQL
#       end
#     end
    add_index :whouses,:uuid
    add_index :whouses,:location_id
    add_index :whouses,:id
    execute 'ALTER TABLE whouses ADD PRIMARY KEY (id)'
  end
end
