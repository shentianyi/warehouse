class AddAncestryToLocationContainers < ActiveRecord::Migration
  def change
    add_column :location_containers, :parent_id, :string
  end
end
