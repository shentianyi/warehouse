class CreateFortliftItems < ActiveRecord::Migration
  def change
    create_table( :fortlift_items, :id=>false) do |t|
      t.string :id, :limit => 36, :primary=>true, :null=>false
      t.string :fortlift_id
      t.string :package_id
      t.string :state, :null=> false, :default => 0

      t.timestamps
    end

    reversible do |dir|
      dir.up do
        execute <<-SQL
        ALTER TABLE fortlift_items
ADD CONSTRAINT fk_fortlift_items_fortlifts
FOREIGN KEY (fortlift_id)
REFERENCES fortlifts(id),
ADD CONSTRAINT fk_fortlift_items_packages
FOREIGN KEY (package_id)
REFERENCES packages(id)
        SQL
      end

      dir.down do
        execute <<-SQL
        ALTER TABLE fortlift_items
DROP FOREIGN KEY fk_fortlift_items_fortlifts,
DROP FOREIGN KEY fk_fortlift_items_packages
        SQL
      end
    end

    add_index :fortlift_items, :id
    add_index :fortlift_items, :fortlift_id
    add_index :fortlift_items, :package_id

    execute 'ALTER TABLE fortlift_items ADD PRIMARY KEY(id)'
  end
end
