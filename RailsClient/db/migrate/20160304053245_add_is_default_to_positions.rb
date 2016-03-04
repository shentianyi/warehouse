class AddIsDefaultToPositions < ActiveRecord::Migration
  def change
    add_column :positions, :is_default, :boolean, default: false
  end
end