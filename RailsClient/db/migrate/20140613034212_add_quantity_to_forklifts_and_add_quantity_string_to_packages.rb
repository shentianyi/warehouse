class AddQuantityToForkliftsAndAddQuantityStringToPackages < ActiveRecord::Migration
  def change
    add_column :forklifts, :sum_packages, :integer, :default => 0
    add_column :forklifts, :accepted_packages, :integer, :default => 0
    add_column :packages, :quantity_str, :string
  end
end
