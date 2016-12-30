class AddDockPointToPosition < ActiveRecord::Migration
  def change
    add_column :positions, :dock_point_id, :integer
  end
end
