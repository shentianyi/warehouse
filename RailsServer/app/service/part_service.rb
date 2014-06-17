class PartService
  def self.validate_id id
    if Part.find_by_id id
      true
    else
      false
    end
  end
end