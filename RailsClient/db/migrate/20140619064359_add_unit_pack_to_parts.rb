class AddUnitPackToParts < ActiveRecord::Migration
  def change
    add_column :parts, :unit_pack, :float
  end
end
