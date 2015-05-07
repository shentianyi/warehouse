class AddDisplayToContainers < ActiveRecord::Migration
  def change
    add_column :containers, :part_id_display, :string
    add_column :containers, :quantity_display, :string
    add_column :containers, :fifo_time_display, :string
  end
end
