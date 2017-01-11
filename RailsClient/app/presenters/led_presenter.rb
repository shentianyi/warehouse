#encoding: utf-8
class LedPresenter<Presenter
  Delegators=[:id, :name, :modem_id, :position_id, :current_state, :led_display, :mac, :order_box_id, :order_car_id]
  def_delegators :led, *Delegators

  def initialize(led)
    @led=led
    self.delegators =Delegators
  end


  def as_basic_info
    {
        id: @led.id,
        modem: @led.modem.blank? ? '' : {id: @led.modem.id, ip: @led.modem.ip, nr: @led.modem.nr}
    }
  end

  def self.as_basic_infos leds
    json=[]
    leds.each do |led|
      json<<LedPresenter.new(led).as_basic_info
    end
    json
  end

  def as_detail
    {
        id: @led.id,
        name: @led.name,
        modem: @led.modem.blank? ? '' : {id: @led.modem.id, ip: @led.modem.ip, nr: @led.modem.nr},
        position: @led.position.blank? ? '' : {id: @led.position.id, detail: @led.position.detail},
        order_box: @led.order_box.blank? ? '' : {id: @led.order_box.id, nr: @led.order_box.nr},
        order_car: @led.order_car.blank? ? '' : {id: @led.order_car.id, nr: @led.order_car.nr},
        current_state: @led.current_state,
        led_display: @led.led_display
    }
  end

  def self.as_details(leds)
    json=[]
    leds.each do |led|
      json<<LedPresenter.new(led).as_detail
    end
    json
  end

end