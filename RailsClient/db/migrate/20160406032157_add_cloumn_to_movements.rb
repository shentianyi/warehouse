class AddCloumnToMovements < ActiveRecord::Migration
  def change
    add_column :movements, :supplier, :string
  end
end
