class Led < ActiveRecord::Base
  include Extensions::UUID
  include Import::LedCsv
  belongs_to :modem
  belongs_to :position
  belongs_to :order_box, class_name: 'OrderBox'
  belongs_to :order_car, class_name: 'OrderCar'

  validates_uniqueness_of :nr, scope: :modem_id, if: :bind_led?
  validate :validate_save


  before_create :init_led_display

  def bind_led?
    self.modem_id.blank? ? false : true
  end

  def init_led_display
    self.led_display = self.led_display.nil? ? '0000' : self.led_display
  end

  # alias :position_id :position
  private

  def validate_save
    errors.add(:id, 'LED编号不可为空') if self.id.blank?
  end



end
