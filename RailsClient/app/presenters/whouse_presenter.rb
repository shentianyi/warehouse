
#encoding: utf-8
class WhousePresenter<Presenter
  Delegators=[:id, :name, :description, :type, :location_id]
  def_delegators :@whouse, *Delegators

  def initialize(whouse)
    @whouse=whouse
    self.delegators =Delegators
  end


  def as_basic_info
    if @whouse.nil?
      nil
    else
      {
          id: @whouse.id,
          name: @whouse.name
      }
    end
  end

end