class AddUnitToParts < ActiveRecord::Migration
  def change
    add_column :parts, :unit, :string
  end
end
