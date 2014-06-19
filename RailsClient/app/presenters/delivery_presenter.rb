class DeliveryPresenter<Presenter
  Delegators=[:id,:user_id,:destination_id,:source_id,:remark,:forklifts,:delivery_date,:received_date,:receiver_id,:receiver,:state]
  def_delegators :@delivery,*Delegators

  def initialize delivery
    @delivery = delivery
    self.delegators = Delegators
  end

  def all_forklifts with_packages
    forklifts=[]
    if with_packages
      ForkliftPresenter.init_presenters(self.forklifts).each do |fp|
        forklifts << fp.to_json_with_packages
      end
    else
      ForkliftPresenter.init_presenters(self.forklifts).each do |fp|
        forklifts << fp.to_json
      end
    end
    forklifts
  end

  def to_json
    {
        id:self.id,
        delivery_date:self.delivery_date,
        received_date:self.received_date,
        receiver_id:self.receiver_id,
        state:self.state,
        state_display:DeliveryState.display(self.state),
        can_delete:DeliveryState.can_delete?(self.state),
        user_id:self.user_id,
        destination_id:self.destination_id,
        remark:self.remark
    }
  end

  def to_json_with_forklifts with_package #boolean?
    {
        id:self.id,
        delivery_date:self.delivery_date,
        received_date:self.received_date,
        receiver_id:self.receiver_id,
        state:self.state,
        state_display:DeliveryState.display(self.state),
        can_delete:DeliveryState.can_delete?(self.state),
        user_id:self.user_id,
        destination_id:self.destination_id,
        remark:self.remark,
        forklifts:self.all_forklifts(with_package)
    }
  end
end