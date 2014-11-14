class CreateMovableRecords < ActiveRecord::Migration
  def up
    create_table :movable_records,:id => false do |t|
      t.string :id, :limit => 36,:primary => true,:null => false
      t.string :movable_id
      t.string :movable_type
      t.string :impl_id  #执行者ID,user_id,sender_id
      t.integer :impl_user_type #执行者类型，类似，0,1,2
      t.string :impl_user #描述执行者类型
      t.string :impl_action #执行的action
      t.datetime :impl_time #执行的时间
      t.string :sourcable_id
      t.string :sourceable_type
      t.string :destinationable_id
      t.string :destinationable_type
      #
      t.boolean :is_delete
      t.boolean :is_new
      t.boolean :is_dirty
      #

      t.timestamps
    end

    add_index :movable_records, :id
    add_index :movable_records, :movable_id
    add_index :movable_records, :impl_id

    execute 'ALTER TABLE movable_records ADD PRIMARY KEY(id)'
  end

  def down
    drop_table :movable_records
  end
end
