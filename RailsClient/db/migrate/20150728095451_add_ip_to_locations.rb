class AddIpToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :ip_detail, :string
  end
end
