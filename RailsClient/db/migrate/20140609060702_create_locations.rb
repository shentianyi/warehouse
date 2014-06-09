class CreateLocations < ActiveRecord::Migration
  def change
    create_table(:locations,:id=>false) do |t|
      t.string :id, :limit=>36, :primary=>true, :null=>false
      t.string :name
      #
      t.boolean :is_delete, :default =>false
      t.boolean :is_dirty, :default => true
      t.boolean :is_new, :default => true
      #
      t.timestamps
    end
    add_index :locations, :id
    execute 'ALTER TABLE locations ADD PRIMARY KEY (id)'
  end
end
