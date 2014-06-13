class CreateDeliveries < ActiveRecord::Migration
  def change
    create_table(:deliveries, :id => false) do |t|
      t.string :uuid, :limit => 36, :null => false
      t.string :id, :limit => 36, :primary => true, :null => false
      t.integer :state, :null=>false, :default=> 1
      t.datetime :delivery_date
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
        ALTER TABLE deliveries
ADD CONSTRAINT fk_deliveries_users
FOREIGN KEY (user_id)
REFERENCES users(id)
        SQL
      end

      dir.down do
        execute <<-SQL
        ALTER TABLE deliveries
DROP FOREIGN KEY fk_deliveries_users
        SQL
      end
    end

    add_index :deliveries, :uuid
    add_index :deliveries, :user_id

    add_index :deliveries, :id

    execute 'ALTER TABLE deliveries ADD PRIMARY KEY (id);'
  end
end
