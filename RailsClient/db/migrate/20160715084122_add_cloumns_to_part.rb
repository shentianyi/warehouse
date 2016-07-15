class AddCloumnsToPart < ActiveRecord::Migration
  def change
    add_column :parts, :mustCheck, :boolean, default: false
    add_column :parts, :checkpattem, :boolean, default: false
    add_column :parts, :isProducable, :boolean, default: false
    add_column :parts, :isFinalProduct, :boolean, default: false
    add_column :parts, :isWipProduct, :boolean, default: false
    add_column :parts, :isPurchasable, :boolean, default: false
    add_column :parts, :isSalable, :boolean, default: false
  end
end