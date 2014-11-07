class AlterForeignKey < ActiveRecord::Migration
  def up
    execute <<-SQL
ALTER TABLE locations
DROP FOREIGN KEY fk_locations_destinations;
    SQL
    execute <<-SQL
ALTER TAbLE part_positions
DROP FOREIGN KEY fk_part_positions_parts,
DROP FOREIGN KEY fk_part_positions_positions;
    SQL
    execute <<-SQL
 ALTER TABLE parts
DROP FOREIGN KEY fk_parts_users;
    SQL
    execute <<-SQL
 ALTER TABLE positions
DROP FOREIGN KEY fk_positions_whouses;
    SQL
    execute <<-SQL
ALTER TABLE users
DROP FOREIGN KEY fk_users_locations;
    SQL
    execute <<-SQL
ALTER TABLE whouses
DROP FOREIGN KEY fk_whouses_locations;
    SQL
  end
end
