class RenameMovableRecordsToActionRecords < ActiveRecord::Migration
  def up
    rename_table :movable_records, :records
    rename_column :records, :movable_id, :recordable_id
    rename_column :records, :movable_type, :recordable_type
  end

  def down
    rename_column :records, :recordable_id, :movable_id
    rename_column :records, :recordable_type, :movable_type
    rename_table :records, :movable_records
  end
end
