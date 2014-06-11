class CreateFortlifts < ActiveRecord::Migration
  def change
    create_table(:fortlifts,:id=>false) do |t|
      t.string :id, :limit => 36, :primary=>true, :null=>false
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
        ALTER TABLE fortlifts
ADD CONSTRAINT fk_fortlifts_deliveries
FOREIGN KEY (delivery_id)
REFERENCES deliveries(id)
        SQL
      end

      dir.down do
        execute <<-SQL
        ALTER TAbLE fortlifts
DROP FOREIGN KEY fk_fortlifts_deliveries
        SQL
      end
    end
    add_index :fortlifts,:delivery_id
    add_index :fortlifts,:id
    execute 'ALTER TABLE fortlifts ADD PRIMARY KEY (id)'
  end
end
