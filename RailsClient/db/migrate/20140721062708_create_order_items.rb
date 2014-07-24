class CreateOrderItems < ActiveRecord::Migration
  def change
    create_table(:order_items,:id=>false) do |t|
    	t.string :uuid, :limited => 36, :null => false
    	t.string :id , :limited => 36, :primary => true, :null => false
    	t.float :quantity
    	t.references :order
    	t.references :location
    	t.references :whouse
    	#t.references :source
    	t.references :user
    	t.references :part
    	t.references :part_type
    	t.timestamps
    end
    add_index :order_items, :uuid
    add_index :order_items, :id
    add_index :order_items, :order_id
    add_index :order_items, :location_id
    add_index :order_items, :source_id
    add_index :order_items, :user_id
    add_index :order_items, :part_id
    add_index :order_items, :part_type_id
    execute 'ALTER TABLE order_items ADD PRIMARY KEY (id)'
  end
end
