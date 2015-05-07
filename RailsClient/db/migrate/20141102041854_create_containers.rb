class CreateContainers < ActiveRecord::Migration
  def up
    create_table :containers, :id => false do |t|
      t.string :id, :limit => 36, :primary => true, :null => false
      t.string :custom_id, :limit => 36 #, :null => false
      t.integer :type
      t.float :quantity
      t.integer :state
      t.string :location_id
      t.string :user_id
      t.string :current_positionable_id
      t.string :current_positionable_type
      t.timestamp :fifo_time
      t.string :remark

      t.string :part_id
      #
      t.boolean :is_delete, :default => false
      t.boolean :is_dirty, :default => true
      t.boolean :is_new, :default => true
      #

      t.timestamps
    end
    add_index :containers, :id
    add_index :containers, :custom_id
    add_index :containers, :location_id

    add_index :containers, :current_positionable_id
    add_index :containers, :current_positionable_type

    add_index :containers, :user_id
    add_index :containers, :type
    add_index :containers, :is_delete
    add_index :containers, :part_id

    execute 'ALTER TABLE containers ADD PRIMARY KEY (id)'
  end

  def down
    drop_table :containers
  end
end