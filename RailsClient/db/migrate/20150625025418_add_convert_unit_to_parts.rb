class AddConvertUnitToParts < ActiveRecord::Migration
  def change
    add_column :parts, :convert_unit, :decimal, precision: 20, scale: 10,default: 1
  end
end
