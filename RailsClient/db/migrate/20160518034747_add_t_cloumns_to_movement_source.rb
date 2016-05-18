class AddTCloumnsToMovementSource < ActiveRecord::Migration
  def change
    add_column :movement_sources, :part_id_display, :string
    add_column :movement_sources, :quantity_display, :string
    add_column :movement_sources, :fifo_time_display, :string
  end
end
