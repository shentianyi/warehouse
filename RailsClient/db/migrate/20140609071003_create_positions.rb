class CreatePositions < ActiveRecord::Migration
  def change
    create_table( :positions,:id => false)do |t|
      t.string :uuid, :limit => 36, :null => false
      t.string :id, :limits=>36, :primary=>true, :null=>false
      t.string :whouse_id
      t.string :detail

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
#         ALTER TABLE positions
# ADD CONSTRAINT fk_positions_whouses
# FOREIGN KEY (whouse_id)
# REFERENCES whouses(id)
#         SQL
#       end
#
#       dir.down do
#         execute <<-SQL
#         ALTER TABlE positions
# DROP FOREIGN KEY fk_positions_whouses
#         SQL
#       end
#     end
    add_index :positions, :uuid
    add_index :positions, :id
    add_index :positions, :whouse_id
    execute 'ALTER TABLE positions ADD PRIMARY KEY (id)'
  end
end
