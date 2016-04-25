class AddRequiredAtToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :required_at, :datetime
  end
end
