class CreatePartTypes < ActiveRecord::Migration
  def up
    create_table :part_types , :id => false do |t|
      t.string :id, :limit => 36, :primary => true, :null => false
      t.string :name

      t.timestamps
    end

    add_index :part_types, :id
    execute 'ALTER TABLE part_types ADD PRIMARY KEY(id)'
  end

  def down
    drop_bable :part_types
  end
end
