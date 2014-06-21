class AddAddressAndTelToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :address, :string
    add_column :locations, :tel, :string
  end
end
