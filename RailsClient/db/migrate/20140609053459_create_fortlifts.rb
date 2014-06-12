class CreateForklifts < ActiveRecord::Migration
  def change
    create_table(:forklifts,:id=>false) do |t|
      t.string :uuid, :limit => 36, :null => false
      t.string :id, :limit => 36, :primary=>true, :null=>false
      t.integer :state, :null=>false, :default=> 1
      #
      t.string :delivery_id
      t.string :remark
      t.string :stocker
      t.string :whouse
      #
      t.boolean :is_delete, :default => false
      t.boolean :is_dirty, :default => true
      t.boolean :is_new, :default => true
      #
      t.timestamps
    end
    reversible do |dir|
      dir.up do
        execute <<-SQL
        ALTER TABLE forklifts
ADD CONSTRAINT fk_forklifts_deliveries
FOREIGN KEY (delivery_id)
REFERENCES deliveries(id)
        SQL
      end

      dir.down do
        execute <<-SQL
        ALTER TAbLE forklifts
DROP FOREIGN KEY fk_forklifts_deliveries
        SQL
      end
    end

    add_index :forklifts, :uuid
    add_index :forklifts,:delivery_id
    add_index :forklifts,:id
    execute 'ALTER TABLE forklifts ADD PRIMARY KEY (id)'
  end
end
