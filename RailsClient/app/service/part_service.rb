class PartService
  def self.validate_id id
    !Part.find_by_id(id).nil?
  end

  def self.import_part_position path

  end
end