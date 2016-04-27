class RenameCloumnToContainer < ActiveRecord::Migration
  def change
    rename_column :containers, :extra_800_no, :extra_fifo
    rename_column :containers, :extra_cz_part_id, :extra_whouse_id
    rename_column :containers, :extra_sh_part_id, :extra_position_id
    rename_column :containers, :extra_unit, :movement_list_id
  end
end
