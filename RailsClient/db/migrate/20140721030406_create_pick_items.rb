class CreatePickItems < ActiveRecord::Migration
  def up
    create_table :pick_items, :id => false do |t|
      t.string :id, :limit => 36, :primary => true, :null => false
      t.string :pick_list_id
      #t.string :order_item_id

      t.float :quantity, :default => 0
      t.integer :box_quantity, :default => 0
      t.string :destination_whouse_id
      t.string :user_id
      t.string :part_id
      t.string :part_type_id
      t.string :remark
      t.boolean :is_emergency, :null => false, :default => false

      #
      t.boolean :is_delete, :default => false
      t.boolean :is_dirty, :default => true
      t.boolean :is_new, :default => true
      #
      t.timestamps
    end

    add_index :pick_items, :id
    add_index :pick_items, :pick_list_id
    add_index :pick_items, :destination_whouse_id
    execute 'ALTER TABLE pick_items ADD PRIMARY KEY(id)'
  end

  def down
    drop_table :pick_items
  end
end
