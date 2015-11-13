class CreateMovementLists < ActiveRecord::Migration
  def change
    create_table( :movement_lists,:id => false)do |t|
      t.string :uuid, :limit => 36, :null => false
      t.string :id, :limits=>36, :primary=>true, :null=>false
      t.string :name, :default => ''
      t.string :state, :default => 100
      t.string :builder
      t.string :remarks, :default => ''

      t.timestamps
    end

    add_index :movement_lists, :uuid
    add_index :movement_lists, :id
    execute 'ALTER TABLE movement_lists ADD PRIMARY KEY (id)'
  end
end
