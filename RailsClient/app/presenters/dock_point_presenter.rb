
#encoding: utf-8
class DockPointPresenter<Presenter
  Delegators=[:id, :nr]
  def_delegators :@dock_point, *Delegators

  def initialize(warehouse)
    @dock_point=warehouse
    self.delegators =Delegators
  end


  def as_basic_info
    if @dock_point.nil?
      nil
    else
      {
          id: @dock_point.id,
          nr: @dock_point.nr
      }
    end
  end

end