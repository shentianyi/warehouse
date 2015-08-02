class AddRemarkToMovements < ActiveRecord::Migration
  def change
    add_column :movements, :remark, :string
  end
end
