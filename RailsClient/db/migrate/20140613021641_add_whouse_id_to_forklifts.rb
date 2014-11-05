class AddWhouseIdToForklifts < ActiveRecord::Migration
  def change
    add_column :forklifts, :whouse_id, :string

#     reversible do |dir|
#       dir.up do
#         execute <<-SQL
#         ALTER TABLE forklifts
# ADD CONSTRAINT fk_forklifts_whouses
# FOREIGN KEY (whouse_id)
# REFERENCES whouses(id)
#         SQL
#       end
#
#       dir.down do
#         execute <<-SQL
#         ALTER TABLE fortlifts
# DROP FOREIGN KEY fk_forklifts_whouses
#         SQL
#       end
#     end

    add_index :forklifts, :whouse_id
  end
end
