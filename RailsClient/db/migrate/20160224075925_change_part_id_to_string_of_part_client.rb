class ChangePartIdToStringOfPartClient < ActiveRecord::Migration
  def change
    change_column :part_clients,:part_id,:string, :limit => 36
  end
end
