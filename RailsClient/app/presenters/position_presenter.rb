
#encoding: utf-8
class PositionPresenter<Presenter
  Delegators=[:id, :nr,:warehouse_id]
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

end