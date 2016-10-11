class AddSixCloumnsToContainer < ActiveRecord::Migration
  def change
    add_column :containers, :extra_carrier, :string
    add_column :containers, :extra_custom_name, :string
    add_column :containers, :extra_destination_address, :string
    add_column :containers, :extra_delivery_date, :datetime
    add_column :containers, :extra_arrive_date, :datetime
  end
end