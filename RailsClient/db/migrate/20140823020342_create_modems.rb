class CreateModems < ActiveRecord::Migration
  def up
    create_table :modems , :id => false do |t|
      t.string :id, :limit => 36, :primary => true, :null => false
      t.string :name
      t.string :ip
      #
      t.boolean :is_delete, :default => false
      t.boolean :is_dirty, :default => true
      t.boolean :is_new, :default => true
      #
      t.timestamps
    end

    add_index :modems, :id

    execute 'ALTER TABLE modems ADD PRIMARY KEY (id)'
  end

  def down
    drop_table :modems
  end
end
