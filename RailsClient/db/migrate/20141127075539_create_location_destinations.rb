class CreateLocationDestinations < ActiveRecord::Migration
  def up
    create_table(:location_destinations,:id => false) do |t|
      t.string :id, :limits => 36, :primary => true, :null => false
      t.string :location_id
      t.string :destination_id
      t.boolean :is_default,:default => false
      #
      t.boolean :is_delete, :default => false
      t.boolean :is_dirty, :default => true
      t.boolean :is_new, :default => true
      #
      t.timestamps
    end

    add_index :location_destinations,:id
    add_index :location_destinations,:location_id
    add_index :location_destinations,:destination_id

    execute 'ALTER TABLE location_destinations ADD PRIMARY KEY (id)'
  end

  def down
    drop_table :location_destinations
  end
end
