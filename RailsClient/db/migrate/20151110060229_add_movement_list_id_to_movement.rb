class AddMovementListIdToMovement < ActiveRecord::Migration
  def change
    add_column :movements, :movement_list_id, :integer
  end
end
