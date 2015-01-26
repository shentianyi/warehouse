class CreateRegexCategories < ActiveRecord::Migration
  def up
    create_table(:regex_categories ,:id => false) do |t|
      t.string :id, :limits => 36, :primary => true, :null => false
      t.string :name
      t.string :desc
      t.integer :type

      #
      t.boolean :is_delete, :default => false
      t.boolean :is_dirty, :default => true
      t.boolean :is_new, :default => true
      #

      t.timestamps
    end
    add_index :regex_categories,:id
    execute 'ALTER TABLE regex_categories ADD PRIMARY KEY (id)'
  end

  def down
    drop_table :regex_categories
  end
end
