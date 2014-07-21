class CreatePickItemFilters < ActiveRecord::Migration
  def up
    create_table :pick_item_filters , :id => false do |t|
      t.string :id, :limit => 36, :primary => true, :null => false
      t.string :user_id
      t.string :value
      t.string :filterable_id
      t.string :filterable_type
      #
      t.boolean :is_delete, :default => false
      t.boolean :is_dirty, :default => true
      t.boolean :is_new, :default => true
      #
      t.timestamps
    end
    add_index :pick_item_filters, :id
    add_index :pick_item_filters, :user_id
    add_index :pick_item_filters, :filterable_id
    add_index :pick_item_filters, :filterable_type

    execute 'ALTER TABLE pick_item_filters ADD PRIMARY KEY(id)'
  end

  def down
    drop_table :pick_item_filters
  end
end
