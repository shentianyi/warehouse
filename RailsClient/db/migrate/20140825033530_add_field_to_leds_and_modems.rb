class AddFieldToLedsAndModems < ActiveRecord::Migration
  def change
    add_column :les ,:mac,:string
  end
end
