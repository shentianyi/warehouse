class CreatePackagePositions < ActiveRecord::Migration
  def change
    create_table(:package_positions, :id=>false )do |t|
      t.string :id ,:limit => 36 ,:primary=>true,:null=>false
      t.string :part_position_id
      t.string :package_id

      #
      t.boolean :is_delete, :default => false
      t.boolean :is_dirty, :default => true
      t.boolean :is_new, :default => true
      #
      t.timestamps
    end

    reversible do |dir|
      dir.up do
        execute <<-SQL
        ALTER TABLE package_positions
ADD CONSTRAINT fk_package_positions_part_positions
FOREIGN KEY (part_position_id)
REFERENCES part_positions(id),

ADD CONSTRAINT fk_package_positions_packages
FOREIGN KEY (package_id)
REFERENCES packages(id)
        SQL
      end
      dir.down do
        execute <<-SQL
        ALTER TABLE package_positions
DROP FOREIGN KEY fk_package_positions_part_positions,
DROP FOREIGN KEY fk_package_positions_packages
        SQL
      end
    end

    add_index :package_positions, :id
    add_index :package_positions, :part_position_id
    add_index :package_positions, :package_id
    execute 'ALTER TABLE package_positions ADD PRIMARY KEY (id)'
  end
end
