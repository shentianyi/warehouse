class CreateLeds < ActiveRecord::Migration
  def up
    create_table :leds, :id => false do |t|
      t.string :id, :limit => 36, :primary => true, :null => false
      t.string :name
      t.string :signal_id
      t.integer :current_state
      #
      t.boolean :is_delete, :default => false
      t.boolean :is_dirty, :default => true
      t.boolean :is_new, :default => true
      #

      t.string :modem_id
      t.string :position

      t.timestamps
    end
    add_index :leds, :id
    add_index :leds, :signal_id
    add_index :leds,:modem_id
    add_index :leds,:position

    execute 'ALTER TABLE leds ADD PRIMARY KEY (id)'
  end

  def down
    drop_table :leds
  end
end
