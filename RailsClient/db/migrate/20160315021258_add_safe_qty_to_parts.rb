class AddSafeQtyToParts < ActiveRecord::Migration
  def change
    add_column :parts, :safe_qty, :float, default: 0
    add_column :parts, :safe_qty_type, :integer, default: SafeQtyType::BY_PACKAGE
  end
end
