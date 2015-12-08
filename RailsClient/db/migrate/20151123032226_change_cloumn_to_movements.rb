class ChangeCloumnToMovements < ActiveRecord::Migration
  def change
    change_column :movements, :movement_list_id, :string
  end
end
