class AddSupplementColumnToPickItem < ActiveRecord::Migration
  # def change
  # end
  def up
    change_table :pick_items do |t|
      t.boolean :is_supplement
    end
  end

  def down
    change_table :pick_items do |t|
      t.remove :is_suppliment
    end
  end
end
