class CreatePartPositions < ActiveRecord::Migration
  def change
    create_table(:part_positions, :id=>false )do |t|
      t.string :id, :limit=>36, :primary=>true, :null => false
      t.string :partnum
      t.string :position_id

      #
      t.boolean :is_delete, :default => false
      t.boolean :is_diraty, :default => true
      t.boolean :is_new, :default => true
      #

      t.timestamps
    end

    reversible do |dir|
      dir.up do
        execute <<-SQL
        ALTER TABLE part_positions
ADD CONSTRAINT fk_part_positions_positions
FOREIGN KEY (position_id)
REFERENCES positions(id)
        SQL
      end

      dir.down do
        execute <<-SQL
        ALTER TABLE part_positions
DROP FOREIGN KEY (position_id)
        SQL
      end
    end
    add_index :part_positions, :id
    add_index :part_positions, :position_id
    add_index :part_positions, :partnum
    execute 'ALTER TABLE part_positions ADD PRIMARY KEY (id)'
  end
end
