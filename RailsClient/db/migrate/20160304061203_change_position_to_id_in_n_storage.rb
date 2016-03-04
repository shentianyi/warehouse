class ChangePositionToIdInNStorage < ActiveRecord::Migration
  def change
    rename_column :n_storages, :position, :position_id
  end
end
