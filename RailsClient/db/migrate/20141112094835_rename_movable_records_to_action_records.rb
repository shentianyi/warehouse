class RenameMovableRecordsToActionRecords < ActiveRecord::Migration
  def change
    rename_table :movable_records,:records
    rename_column :records, :movable_id,:recordable_id
    rename_column :records, :movable_type,:recordable_type
  end
end
