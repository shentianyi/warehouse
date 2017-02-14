class AddCloumnsToParts < ActiveRecord::Migration
  def change
    add_column :parts, :name, :string
    add_column :parts, :cross_section, :float
    add_column :parts, :weight, :float
    add_column :parts, :weight_range, :float, default: 0.1
  end
end
