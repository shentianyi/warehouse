class CreatePartTypes < ActiveRecord::Migration
  def up
    create_table :part_types,:id => false do |t|
      t.string :id, :limit => 36, :primary => true, :null => false
      t.string :name
      #
      t.boolean :is_delete, :default => false
      t.boolean :is_dirty, :default => true
      t.boolean :is_new, :default => true
      #
      t.timestamps
    end

    add_index :part_types, :id
    execute 'ALTER TABLE part_types ADD PRIMARY KEY(id)'
  end

  def down
    drop_table :part_types
  end
end
