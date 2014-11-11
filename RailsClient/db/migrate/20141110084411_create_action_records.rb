class CreateActionRecords < ActiveRecord::Migration
  def up
    create_table :action_records, :id => false do |t|
      t.string :id, :limit => 36, :primary => true, :null => false
      t.string :actionable_id
      t.string :actionable_type
      t.string :impl_id #who call this action？User or Some Machine
      t.string :impler_type #type of impler,like sender,checker,receiver
      t.integer :impl_type #Type of implementation like,from Scanner or Manual
      t.timestamps :impl_time #Time of call this action

      #
      t.boolean :is_delete, :default => false
      t.boolean :is_dirty, :default => false
      t.boolean :is_new, :default => true
      #
      t.timestamps
    end
  end

  def down
    drop_table :action_records
  end
end
