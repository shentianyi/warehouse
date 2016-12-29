
#encoding: utf-8
class PositionPresenter<Presenter
  Delegators=[:id, :nr,:warehouse_id, :detail, :dock_point_id]
  def_delegators :@position, *Delegators

  def initialize(warehouse)
    @position=warehouse
    self.delegators =Delegators
  end


  def as_basic_info
    if @position.nil?
      nil
    else
      {
          id: @position.id,
          nr: @position.id,
          name: @position.detail
      }
    end
  end

  def as_agv_info
    {
        id: @position.id,
        detail: @position.detail,
        led: @position.led.blank? ? '' : LedPresenter.new(@position.led).as_basic_info,
        dock_point: @position.dock_point.blank? ? '' : DockPointPresenter.new(@position.dock_point).as_basic_info
    }
  end

  def self.as_agv_infos positions
    json=[]
    positions.each do |position|
      json<<PositionPresenter.new(position).as_agv_info
    end
    json
  end

end