class MovementList < ActiveRecord::Base
  include Extensions::UUID

  has_many :movements, dependent: :destroy
  validate :validate_save

  def validate_save
    errors.add(:id, '编号不可为空') if self.id.blank?
  end

  def generate_id
    "Y#{Time.now.to_milli}"
  end
end
