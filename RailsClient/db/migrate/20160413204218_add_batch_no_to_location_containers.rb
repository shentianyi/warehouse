class AddBatchNoToLocationContainers < ActiveRecord::Migration
  def change
    add_column :location_containers, :batch_no, :string
  end
end
