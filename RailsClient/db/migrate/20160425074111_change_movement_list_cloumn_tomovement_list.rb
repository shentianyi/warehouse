class ChangeMovementListCloumnTomovementList < ActiveRecord::Migration
  def change
    change_column :movement_sources, :movement_list_id, :string
  end
end
