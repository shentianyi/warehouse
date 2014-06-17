class RemoveSomeUnusedColumns < ActiveRecord::Migration
  def change
    remove_column :part_positions,:position_detail
    remove_column :part_positions,:whouse_name
  end
end
