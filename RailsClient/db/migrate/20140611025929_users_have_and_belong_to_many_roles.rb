class UsersHaveAndBelongToManyRoles < ActiveRecord::Migration
  def change
    create_table :roles_users, :id => false do |t|
      t.string :role_id
      t.string :user_id
    end

    reversible do |dir|
      dir.up do
        execute <<-SQL
        ALTER TABLE roles_users
ADD CONSTRAINT fk_roles_users_roles
FOREIGN KEY (role_id)
REFERENCES roles(id),
ADD CONSTRAINT fk_roles_users_users
FOREIGN KEY (user_id)
REFERENCES users(id)
        SQL
      end

      dir.down do
        execute <<-SQL
        ALTER TABLE roles_users
DROP FOREIGN KEY fk_roles_users_roles,
DROP FOREIGN KEY fk_roles_users_users
        SQL
      end
    end
  end

  def down
    drop_table :roles_users
  end
end
