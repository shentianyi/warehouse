class CreateRoles < ActiveRecord::Migration
  def change
    create_table(:roles, :id=>false) do |t|
      t.string :id, :limit => 36, :primary => true, :null => false
      t.string :name

      t.timestamps
    end

    add_index :roles, :id
    execute 'ALTER TABLE roles ADD PRIMARY KEY (id)'
  end
end
