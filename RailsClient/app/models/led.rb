class Led < ActiveRecord::Base
  include Extensions::UUID
  include Import::LedCsv
  belongs_to :modem

  validate :validate_save
  after_save :send_led_message

  def singnal_id_in_hex
    self.signal_id.to_i.to_s(16).rjust(4,'0').scan(/.{2}/).join(' ')
  end

  private

  def validate_save
    errors.add(:signal_id, 'LED编号不可为空') if self.signal_id.blank?
    errors.add(:modem, '解调器不存在') if self.modem.nil?
    errors.add(:position, '库位不存在') unless Position.find_by_detail(self.position) unless self.position.blank?
    q=self.class.where(signal_id: self.signal_id, modem_id: self.modem_id)
    q=q.where('id<>?', self.id) unless new_record?
    errors.add(:signal_id, '同一个解调器下不可重复LED编号') if q.first
  end

  def send_led_message
    if self.current_state_changed? && !self.current_state.blank? && (modem=self.modem)
      if msg=LedState.get_message_by_state(self.current_state)
        #msg="#{msg} #{self.signal_id}"
        puts msg
        msg=msg.split(' ').map { |m| m.to_i.to_s(16).scan(/.{1,2}/).map { |mm| mm.rjust(2, '0') } }.join(' ')
        msg="#{msg} #{self.singnal_id_in_hex}"
        #msg=URI::escape("#{msg} #{self.signal_id}")
        puts msg
        #puts LedService.send_msg(msg, modem.ip).to_json
      end
    end
  end


end
