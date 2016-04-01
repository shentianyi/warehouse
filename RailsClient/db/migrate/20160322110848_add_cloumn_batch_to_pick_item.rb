class AddCloumnBatchToPickItem < ActiveRecord::Migration
  def change
    add_column :pick_items, :batch_nr, :string
  end
end
