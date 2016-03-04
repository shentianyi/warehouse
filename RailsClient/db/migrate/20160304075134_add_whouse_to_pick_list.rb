class AddWhouseToPickList < ActiveRecord::Migration
  def change
    add_column :pick_lists, :whouse_id, :string
    add_index :pick_lists, :whouse_id
  end
end
