class AddFieldsToSysConfig < ActiveRecord::Migration
  def change
    add_column :sys_configs, :category, :string
    add_column :sys_configs, :index, :integer
    add_column :sys_configs, :description, :string
  end
end
