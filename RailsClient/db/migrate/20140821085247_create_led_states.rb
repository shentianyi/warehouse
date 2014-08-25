class CreateLedStates < ActiveRecord::Migration
  def up
    create_table :led_states,:id=>false do |t|
      t.string :id, :limit => 36, :primary => true, :null => false
      t.integer :state
      t.string :rgb
      t.integer :led_code
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
