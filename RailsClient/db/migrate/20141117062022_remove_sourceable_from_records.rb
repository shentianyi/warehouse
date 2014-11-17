class RemoveSourceableFromRecords < ActiveRecord::Migration
  def change
    remove_column :records,:sourcable_id
    remove_column :records,:sourceable_type
  end
end
