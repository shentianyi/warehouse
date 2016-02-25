class PartType < ActiveRecord::Base
  include Extensions::UUID
  include Import::PartTypeCsv

  has_many :parts
  #
  #  validate :validate_save
  # def validate_save
  #  if self.id_changed? && self.persisted?
  #    errors.add(:id,'存在此类型零件，请先修改零件，在修改此类型')  if Part.where(part_type_id:self.id_was).count>0
  #  end
  # end
end
