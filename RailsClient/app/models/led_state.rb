class LedState < ActiveRecord::Base
  include Extensions::UUID

  validate :validate_create_update

  private
  def validate_create_update
    errors.add(:name, "不能重复") if LedState.where(:name => self.name).first if new_record?
    errors.add(:name, "不能重复") if LedState.where(:name => self.name).where('id<>?', self.id).first unless new_record?
  end
end
