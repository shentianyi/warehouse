class CreateParts < ActiveRecord::Migration
  def change
    create_table(:parts, :id=>false) do |t|
      t.string :uuid, :limit => 36, :null => false
      t.string :id , :limit => 36, :primary=>true, :null=>false
      t.string :customernum
      t.string :creator_id
      #
      t.boolean :is_delete, :default =>false
      t.boolean :is_dirty, :default => true
      t.boolean :is_new, :default => true
      #
      t.timestamps
    end

    reversible do |dir|
      dir.up do
        execute <<-SQL
        ALTER TABLE parts
ADD CONSTRAINT fk_parts_creators
FOREIGN KEY (creator_id)
REFERENCES users(id)
        SQL
      end

      dir.down do
        execute <<-SQL
        ALTER TABLE parts
DROP FOREIGN KEY creator_id
        SQL
      end
    end

    add_index :parts, :uuid
    add_index :parts, :id
    add_index :parts, :creator_id

    execute 'ALTER TABLE parts ADD PRIMARY KEY (id)'
  end
end
