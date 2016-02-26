class AddCloumnsToContainer < ActiveRecord::Migration
  def change
    add_column :containers, :extra_800_no, :string
    add_column :containers, :extra_cz_part_id, :string
    add_column :containers, :extra_sh_part_id, :string
    add_column :containers, :extra_unit, :string
    add_column :containers, :extra_batch, :string
  end
end
