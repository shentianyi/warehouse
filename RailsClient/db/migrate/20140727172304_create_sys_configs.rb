class CreateSysConfigs < ActiveRecord::Migration
  def up
    create_table :sys_configs, :id => false do |t|
      t.string :id, :limited => 36, :primary => true, :null => false
      t.string :code
      t.string :value
      t.string :name
      t.string :remark

      t.boolean :is_delete, :default => false
      t.boolean :is_dirty, :default => true
      t.boolean :is_new, :default => true


      t.timestamps
    end

    add_index :sys_configs, :id
    add_index :sys_configs, :code
    execute 'ALTER TABLE sys_configs ADD PRIMARY KEY (id)'
  end

  def down
    drop_table :sys_configs
  end
end
