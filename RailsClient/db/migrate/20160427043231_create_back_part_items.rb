class CreateBackPartItems < ActiveRecord::Migration
  def up
    create_table :back_part_items, :id => false do |t|
      t.string :id, :limit => 36, :primary => true, :null => false
      t.references :back_part, index: true
      t.references :part, index: true
      t.float :qty, :default => 0
      t.references :whouse, index: true
      t.references :position, index: true
      t.string :back_reason
      t.string :remark
      t.boolean :has_sample, :null => false, :default => false

      t.timestamps
    end

    add_index :back_part_items, :id
    execute 'ALTER TABLE back_part_items ADD PRIMARY KEY(id)'
  end

  def down
    drop_table :back_part_items
  end
end
