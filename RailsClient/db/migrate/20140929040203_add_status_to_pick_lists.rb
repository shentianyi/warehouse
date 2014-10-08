class AddStatusToPickLists < ActiveRecord::Migration
  def change
    add_column :pick_lists, :status, :integer, :default => 0
  end
end
