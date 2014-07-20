class AddSourceableToPartPosition < ActiveRecord::Migration
  def change
    add_column :part_positions, :sourceable_id, :string
    add_column :part_positions, :sourceable_type, :string
    add_index :part_positions,:sourceable_id
    add_index :part_positions,:sourceable_type
  end
end
