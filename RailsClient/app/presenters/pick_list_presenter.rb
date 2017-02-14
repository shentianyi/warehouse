#encoding: utf-8
class PickListPresenter<Presenter
  Delegators=[:id, :user_id, :state, :whouse_id]
  def_delegators :@pick, *Delegators

  def initialize(pick)
    @pick=pick
    self.delegators =Delegators
  end


  def as_basic_info
    {
        id: @pick.id,
        status: @pick.state,
        remark: @pick.remark.blank? ? '' : @pick.remark
    }
  end

  def orderable_nr
    if (order=@pick.orders.first) && (orderable=order.orderable)
      orderable.nr
    else
      ''
    end
  end

  def as_detail
    {
        id: @pick.id,
        nr: @pick.nr,
        status: @pick.state,
        orderable_nr: orderable_nr,
        remark: @pick.remark
    }
  end

  def self.as_details(picks)
    json=[]
    picks.each do |pick|
      json<<PickListPresenter.new(pick).as_basic_info
    end
    json
  end

end