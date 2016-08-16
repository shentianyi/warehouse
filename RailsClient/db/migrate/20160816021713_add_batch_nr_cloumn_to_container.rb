class AddBatchNrCloumnToContainer < ActiveRecord::Migration
  def change
    add_column :containers, :batch_nr, :string
  end
end
