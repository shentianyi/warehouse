class ChangeCloumnToOrderCars < ActiveRecord::Migration
  def change
    change_column :order_cars, :whouse_id, :string
  end
end
