class CreateOrderItems < ActiveRecord::Migration
  def up
    create_table(:order_items,:id=>false) do |t|
    	t.string :uuid, :limited => 36, :null => false
    	t.string :id , :limited => 36, :primary => true, :null => false
    	t.float :quantity
      t.integer :box_quantity, :default => 0
    	t.string :order_id
    	t.string :location_id
      #t.string :source_id
    	t.string :whouse_id
    	t.string :user_id
    	t.string :part_id
    	t.string :part_type_id
      t.string :remark
      t.boolean :is_emergency ,:null => false,:default => false

      t.boolean :is_delete, :default => false
      t.boolean :is_dirty, :default => true
      t.boolean :is_new, :default => true

    	t.timestamps
    end
    add_index :order_items, :uuid
    add_index :order_items, :id
    add_index :order_items, :order_id
    add_index :order_items, :location_id
    #add_index :order_items, :source_id
    add_index :order_items, :whouse_id
    add_index :order_items, :user_id
    add_index :order_items, :part_id
    add_index :order_items, :part_type_id
    execute 'ALTER TABLE order_items ADD PRIMARY KEY (id)'
  end

  def down
    drop_table :order_items
  end
end
