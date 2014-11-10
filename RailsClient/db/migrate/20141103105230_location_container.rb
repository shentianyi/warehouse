class LocationContainer < ActiveRecord::Migration
  def up
    create_table :location_containers, :id => false do |t|
      t.string :id, :limit => 36, :primary => true, :null => false
      t.string :location_id
      t.string :user_id
      t.string :container_id
      t.string :remark
      #
      t.boolean :is_delete, :default => false
      t.boolean :is_dirty, :default => true
      t.boolean :is_new, :default => true
      #
      t.timestamps
    end
    add_index :location_containers, :id
    add_index :location_containers, :location_id
    add_index :location_containers, :container_id

    execute 'ALTER TABLE location_containers ADD PRIMARY KEY (id)'
  end

  def down
    drop_table :location_containers
  end
end
