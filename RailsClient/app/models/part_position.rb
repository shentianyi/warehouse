class PartPosition < ActiveRecord::Base
  include Extensions::UUID
  belongs_to :position
  belongs_to :part

  FK=[:position_id, :part_id]

  before_update :set_update_flag
  private
  def set_update_flag
    if self.part_id_changed? || self.position_id_changed?
      new_part_id=self.part_id
      new_position_id=self.position_id
      PartPosition.create(part_id: new_part_id, position_id: new_position_id)
      self.part_id=self.part_id_was
      self.position =self.position_was
      self.delete=true
    end
  end
end
