class CreateApiLogs < ActiveRecord::Migration
  def change
    create_table(:api_logs,:id=>false) do |t|
      t.string :id, :limit=>36, :primary=>true, :null=>false
      t.string :user_id
      t.string :targetable_id
      t.string :targetable_type
      t.string :action
      t.string :action_code
      t.boolean :result
      t.string :message
      #
      t.boolean :is_delete, :default => false
      t.boolean :is_dirty, :default => true
      t.boolean :is_new, :default => true
      #
      t.timestamps
    end

    add_index :api_logs, :id
    add_index :api_logs, :user_id
    add_index :api_logs, :targetable_id
    execute 'ALTER TABLE api_logs ADD PRIMARY KEY (id)'
  end

  def down
    drop_table :api_logs
  end
end
