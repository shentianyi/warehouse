class AddPrefixAndSuffixToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :prefix, :string, :default=>'-1'
    add_column :locations, :suffix, :string, :default=>'-1'
  end
end
