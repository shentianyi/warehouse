class CreateBackParts < ActiveRecord::Migration
  def up
    create_table :back_parts, :id => false do |t|
      t.string :id, :limit => 36, :primary => true, :null => false
      t.string :user_id
      t.string :des_location_id
      t.string :src_location_id
      t.integer :state, :default => 100

      t.timestamps
    end
    add_index :back_parts, :id
    add_index :back_parts, :user_id
    add_index :back_parts, :des_location_id
    add_index :back_parts, :src_location_id
    execute 'ALTER TABLE back_parts ADD PRIMARY KEY(id)'
  end

  def down
    drop_table :back_parts
  end
end
