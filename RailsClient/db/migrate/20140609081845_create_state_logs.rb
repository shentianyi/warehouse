class CreateStateLogs < ActiveRecord::Migration
  def change
    create_table(:state_logs,:id=>false) do |t|
      t.string :id, :limit=>36, :primary=>true, :null=>false

      t.string :stateable_id
      t.string :stateable_type
      #
      t.boolean :is_delete, :default => false
      t.boolean :is_dirty, :default => true
      t.boolean :is_new, :default => true
      #

      t.integer :state_before
      t.integer :state_after
      t.timestamps
    end

    add_index :state_logs, :id
    execute 'ALTER TABLE state_logs ADD PRIMARY KEY (id);'
  end
end
