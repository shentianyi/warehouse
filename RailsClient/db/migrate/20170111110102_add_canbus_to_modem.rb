class AddCanbusToModem < ActiveRecord::Migration
  def change
    add_column :modems, :nr, :string
  end
end
