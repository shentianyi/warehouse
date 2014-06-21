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
        id:self.id.to_s,
        delivery_date:self.delivery_date.to_s,
        received_date:self.received_date.to_s,
        receiver_id:self.receiver_id.to_s,
        state:self.state.to_s,
        state_display:DeliveryState.display(self.state).to_s,
        can_delete:DeliveryState.can_delete?(self.state).to_s,
        user_id:self.user_id.to_s,
        destination_id:self.destination_id.to_s,
        remark:self.remark.to_s,
        forklifts:self.all_forklifts(with_package)
    }
  end
end