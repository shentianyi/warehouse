class AddMovementListToMovements < ActiveRecord::Migration
  def change
    add_column :movements, :movement_list_id, :string
  end
end
