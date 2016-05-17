class AddIsMrpWhouseToWhouses < ActiveRecord::Migration
  def change
    add_column :whouses, :is_mrp_whouse, :boolean, default: false
  end
end
