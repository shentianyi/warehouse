class AddSupplmentColumnToOrderItem < ActiveRecord::Migration
  # def change
  #   add_column :order_items, :is_supplement, :boolean
  # end
  def up
    change_table :order_items do |t|
      t.boolean :is_supplement
    end
  end

  def down
    change_table :order_items do |t|
      t.remove :is_supplment
    end
  end
end
