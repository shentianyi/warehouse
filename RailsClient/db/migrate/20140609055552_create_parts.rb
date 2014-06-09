class CreateParts < ActiveRecord::Migration
  def change
    create_table(:parts, :id=>false) do |t|
      t.string :id , :limit => 36, :primary=>true, :null=>false
      t.string :partnum
      t.string :customernum
      #
      t.boolean :is_delete, :default =>false
      t.boolean :is_dirty, :default => true
      t.boolean :is_new, :default => true
      #
      t.timestamps
    end
    add_index :parts, :id
    add_index :parts, :partnum
    execute 'ALTER TABLE parts ADD PRIMARY KEY (id)'
  end
end
