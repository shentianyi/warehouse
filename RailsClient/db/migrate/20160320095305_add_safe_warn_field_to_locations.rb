class AddSafeWarnFieldToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :is_open_safe_qty, :boolean, default: false
    add_column :locations, :safe_qty_emails, :text
  end
end
