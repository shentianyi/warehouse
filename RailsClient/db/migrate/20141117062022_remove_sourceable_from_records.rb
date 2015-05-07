class RemoveSourceableFromRecords < ActiveRecord::Migration
  def up
    remove_column :records, :sourcable_id
    remove_column :records, :sourceable_type
  end

  def down
    add_column :records, :sourcable_id, :string
    add_column :records, :sourceable_type, :string
  end
end
