class ChangeToMovements < ActiveRecord::Migration
  def change
    remove_column :movements, :qty, :integer
    add_column :movements, :qty, :decimal, precision: 9, scale: 2
  end
end
