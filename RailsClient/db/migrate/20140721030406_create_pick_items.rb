class CreatePickItems < ActiveRecord::Migration
  def up
    create_table :pick_items, :id => false do |t|
      t.string :id, :limit => 36, :primary => true, :null => false
      t.string :pick_list_id
      t.string :order_item_id
      #
      t.boolean :is_delete, :default => false
      t.boolean :is_dirty, :default => true
      t.boolean :is_new, :default => true
      #
      t.timestamps
    end

    add_index :pick_items, :id
    add_index :pick_items, :pick_list_id
    add_index :pick_items, :order_item_id
    execute 'ALTER TABLE pick_items ADD PRIMARY KEY(id)'
  end

  def down
    drop_table :pick_items
  end
end
