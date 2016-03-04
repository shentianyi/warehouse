class PartPosition < ActiveRecord::Base
  include Extensions::UUID
  include Import::PartPositionCsv
  belongs_to :position
  belongs_to :part

  belongs_to :from_position, class_name: 'Position'
  belongs_to :from_warehouse, class_name: 'Whouse'

  belongs_to :sourceable, polymorphic: true

  validates_uniqueness_of :part_id, :scope => :position_id

  FK=%w(position_id part_id)

  before_update :set_update_flag

  # before_create :check_uniq
  #
  # def check_uniq
  #   unless PartPosition.where(part_id: self.part_id, position_id: self.position_id).blank?
  #     errors.add(:part_id, "该零件#{self.part_id}\位置#{self.position_id}对应信息已存在")
  #     return false
  #   end
  # end

  private
  def set_update_flag
    if self.part_id_changed? || self.position_id_changed?
      new_part_id=self.part_id
      new_position_id=self.position_id
      sourceable = self.sourceable
      PartPosition.create(part_id: new_part_id, position_id: new_position_id,sourceable: sourceable)
      self.part_id=self.part_id_was
      self.position_id =self.position_id_was
      self.is_delete=true
    end
  end
end
