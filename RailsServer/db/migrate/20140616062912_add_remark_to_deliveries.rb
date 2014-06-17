class AddRemarkToDeliveries < ActiveRecord::Migration
  def change
    add_column :deliveries, :remark, :string
  end
end
