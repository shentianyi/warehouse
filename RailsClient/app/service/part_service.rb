class PartService
  def self.validate_id id
    !Part.find_by_id(id).nil?
  end
end