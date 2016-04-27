class ChangeCloumnToBackPartItem < ActiveRecord::Migration
  def change
    change_column :back_part_items,:back_part_id,:string
    change_column :back_part_items,:part_id,:string
    change_column :back_part_items,:whouse_id,:string
    change_column :back_part_items,:position_id,:string
  end
end
