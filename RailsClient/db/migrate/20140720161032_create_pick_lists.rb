class CreatePickLists < ActiveRecord::Migration
  def up
    create_table :pick_lists, :id => false do |t|
      t.string :id, :limit => 36, :primary => true, :null => false
      t.string :user_id
      t.integer :state
      #
      t.boolean :is_delete, :default => false
      t.boolean :is_dirty, :default => true
      t.boolean :is_new, :default => true
      #
      t.timestamps
    end
    add_index :pick_lists, :id
    add_index :pick_lists, :user_id
    execute 'ALTER TABLE pick_lists ADD PRIMARY KEY(id)'
  end

  def down
    drop_table :pick_lists
  end
end
