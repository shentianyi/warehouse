class LedState < ActiveRecord::Base
  include Extensions::UUID

  validate :validate_create_update

  def self.get_message_by_state state
    ls = LedState.find_by_state state
    return nil if ls.nil?
    return "#{ls.rgb} #{ls.led_code}"
  end

  def R
    self.rgb.split(" ")[0]
  end

  def G
    self.rgb.split(" ")[1]
  end

  def B
    self.rgb.split(" ")[2]
  end

  private
  def validate_create_update
    errors.add(:state, "不能重复") if LedState.where(:state => self.state).first if new_record?
    errors.add(:state, "不能重复") if LedState.where(:state => self.state).where('id<>?', self.id).first unless new_record?
  end
end
