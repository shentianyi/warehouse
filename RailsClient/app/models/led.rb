class Led < ActiveRecord::Base
  include Extensions::UUID
  include Import::LedCsv
  belongs_to :modem
  belongs_to :position

  validate :validate_save

  # alias :position_id :position
  private

  def validate_save
    errors.add(:id, 'LED编号不可为空') if self.id.blank?
  end



end
