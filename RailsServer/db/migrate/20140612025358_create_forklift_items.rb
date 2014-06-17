class CreateForkliftItems < ActiveRecord::Migration
  def change
=begin
    create_table( :forklift_items, :id=>false) do |t|
      t.string :uuid, :limit => 36, :null => false
      t.string :id, :limit => 36, :primary=>true, :null=>false
      t.string :forklift_id
      t.string :package_id
      t.string :state, :null=> false, :default => 0
      t.string :user_id

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
        ALTER TABLE forklift_items
ADD CONSTRAINT fk_forklift_items_forklifts
FOREIGN KEY (forklift_id)
REFERENCES forklifts(id),
ADD CONSTRAINT fk_forklift_items_packages
FOREIGN KEY (package_id)
REFERENCES packages(id),
ADD CONSTRAINT fk_forklift_items_users
FOREIGN KEY (user_id)
REFERENCES users(id)
        SQL
      end

      dir.down do
        execute <<-SQL
        ALTER TABLE forklift_items
DROP FOREIGN KEY fk_forklift_items_forklifts,
DROP FOREIGN KEY fk_forklift_items_packages,
DROP FOREIGN KEY fk_forklift_items_users
        SQL
      end
    end

    add_index :forklift_items, :id
    add_index :forklift_items, :uuid
    add_index :forklift_items, :forklift_id
    add_index :forklift_items, :package_id
    add_index :forklift_items, :user_id

    execute 'ALTER TABLE forklift_items ADD PRIMARY KEY(id)'
=end
  end
end
