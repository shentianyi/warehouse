class CreateLocationContainerHierarchies < ActiveRecord::Migration
  def change
    create_table :location_container_hierarchies, id: false do |t|
      t.string :ancestor_id, null: false
      t.string :descendant_id, null: false
      t.integer :generations, null: false
    end

    add_index :location_container_hierarchies, [:ancestor_id, :descendant_id, :generations],
              unique: true,
              name: 'anc_desc_idx'

    add_index :location_container_hierarchies, [:descendant_id],
              name: 'desc_idx'
  end
end
