class CreateLedStates < ActiveRecord::Migration
  def change
    create_table :led_states,:id=>false do |t|
      t.string :id, :limit => 36, :primary => true, :null => false
      t.string :name
      t.string :rgb
      t.string :led_code
      #
      t.boolean :is_delete, :default => false
      t.boolean :is_dirty, :default => true
      t.boolean :is_new, :default => true
      #
      t.timestamps
    end
    execute 'ALTER TABLE led_states ADD PRIMARY KEY (id)'
  end

  def down
    drop_table :led_states
  end
end
