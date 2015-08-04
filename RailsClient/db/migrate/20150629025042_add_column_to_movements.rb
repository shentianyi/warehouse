class AddColumnToMovements < ActiveRecord::Migration
  def change
    add_column :movements, :remarks, :string
    add_column :movements, :employee_id, :string
  end
end
