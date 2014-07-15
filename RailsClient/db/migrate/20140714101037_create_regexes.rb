class CreateRegexes < ActiveRecord::Migration
  def up
    create_table :regexes, :id => false do |t|
      t.string :id, :limit => 36, :primary => true, :null => false
      t.string :name, :null => false
      t.string :code, :null => false
      t.integer :prefix_length, :default => 0
      t.string :prefix_string
      t.integer :type, :null => false
      t.integer :suffix_length, :default => 0
      t.integer :suffix_string
      t.string :regex_string, :default => ''
      t.string :regexable_id
      t.string :regexable_type
      t.string :remark
      t.boolean :is_sys_default,:default=>false
      #
      t.boolean :is_delete, :default => false
      t.boolean :is_dirty, :default => true
      t.boolean :is_new, :default => true
      #

      t.timestamps
    end

    add_index :regexes, :id
    add_index :regexes, :regexable_id
    add_index :regexes, :regexable_type
    execute 'ALTER TABLE regexes ADD PRIMARY KEY(id)'
  end

  def down
    drop_table :regexes
  end
end
