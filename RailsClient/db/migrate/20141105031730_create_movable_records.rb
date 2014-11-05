class CreateMovableRecords < ActiveRecord::Migration
  def change
    create_table :movable_records,:id => false do |t|
      t.string :id, :limit => 36, :primary => true, :null => false
      t.string :movable_id
      t.string :movable_type
      t.string :destination_id
      t.string :action
      t.integer :state

      #
      t.boolean :is_delete, :default => false
      t.boolean :is_dirty, :default => true
      t.boolean :is_new, :default => true
      #
      t.timestamps
    end

    add_index :movable_records, :id
    add_index :movable_records, :movable_id
    add_index :movable_records, :destination_id

    execute 'ALTER TABLE movable_records ADD PRIMARY KEY(id)'
  end
end
