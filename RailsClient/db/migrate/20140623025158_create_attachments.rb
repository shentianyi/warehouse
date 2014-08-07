class CreateAttachments < ActiveRecord::Migration
  def up
    create_table :attachments, :id => false do |t|
      t.string :id, :limit => 36, :primary => true, :null => false
      t.string :name
      t.string :path
      t.float :size
      t.string :path_name
      t.string :attachable_id
      t.string :attachable_type
      t.string :version
      t.text :md5
      t.string :type

      #
      t.boolean :is_delete, :default => false
      t.boolean :is_dirty, :default => true
      t.boolean :is_new, :default => true
      #

      t.timestamps
    end

    add_index :attachments, :attachable_id
    add_index :attachments, :attachable_type
    add_index :attachments, :id
    execute 'ALTER TABLE attachments ADD PRIMARY KEY (id)'
  end

  def down
    drop_table :attachments
  end
end
