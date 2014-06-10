class CreatePackages < ActiveRecord::Migration
  def change
    create_table(:packages, :id=>false )do |t|
      t.string :id,:limits=>36, :primary=>true, :null=>false
      t.string :partnum
      t.integer :quantity, :default=>0
      t.integer :state
      t.string :location_id
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
        ALTER TABLE packages
ADD CONSTRAINT fk_packages_locations
FOREIGN KEY (location_id)
REFERENCES locations(id)
        SQL
      end

      dir.down do
        execute <<-SQL
        ALTER TABLE packages
DROP FOREIGN KEY fk_packages_locations
        SQL
      end
    end
    add_index :packages, :id
    add_index :packages, :location_id
    execute 'ALTER TABLE packages ADD PRIMARY KEY (id)'
  end
end
