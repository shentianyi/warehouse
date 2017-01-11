class CreateOrderBoxTypes < ActiveRecord::Migration
  def change
    create_table :order_box_types do |t|
      t.string :name
      t.string :description
      t.float :weight

      t.timestamps
    end
  end
end
