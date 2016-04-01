class MovementList < ActiveRecord::Base
  # include Extensions::UUID

  has_many :movements, dependent: :destroy
  has_many :movement_sources, dependent: :destroy
  validates_uniqueness_of :id
  validate :validate_save
  after_initialize :generate_uuid

  def generate_uuid
    self.id = self.send(:generate_id) if self.id.nil? && self.respond_to?(:generate_id)
    self.id = SecureRandom.uuid if self.id.nil?
    self.uuid= SecureRandom.uuid if self.respond_to?(:uuid) and self.send(:uuid).nil?
  end

  def validate_save
    errors.add(:id, '编号不可为空') if self.id.blank?
  end

  def generate_id
    "Y#{Time.now.to_milli}"
  end
end
