class AddAncestryToLocationContainers < ActiveRecord::Migration
  def change
    # add_column :location_containers, :parent_id, :string
    add_column :location_containers, :ancestry, :string
    add_index :location_containers, :ancestry
  end
end
