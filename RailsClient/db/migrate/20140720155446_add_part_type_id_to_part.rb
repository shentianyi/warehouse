class AddPartTypeIdToPart < ActiveRecord::Migration
  def change
    add_column :parts, :part_type_id, :string
    add_index :parts,:part_type_id
  end
end
