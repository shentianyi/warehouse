class AddStateToPickItems < ActiveRecord::Migration
  def change
    add_column :pick_items,:state,:integer,:default => 0
  end
end
