class CreateStorages < ActiveRecord::Migration
  def up
    create_table(:storages, :id => false) do |t|
      t.string :id, :limits => 36, :primary => true, :null => false
      t.string :location_id
      t.string :part_id
      t.float :quantity
      t.datetime :fifo_time

      t.string :storable_id
      t.string :storable_type
      #
      t.boolean :is_delete, :default => false
      t.boolean :is_dirty, :default => true
      t.boolean :is_new, :default => true
      #

      t.timestamps
    end
    add_index :storages, :id
    add_index :storages, :location_id
    add_index :storages, :part_id
    add_index :storages, :storable_id
    add_index :storages, :storable_type

    execute 'ALTER TABLE storages ADD PRIMARY KEY (id)'
  end

  def down
    drop_table :storages
  end
end
