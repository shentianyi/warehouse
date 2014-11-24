class DeliveryPresenter<Presenter
  Delegators=[:id, :container_id, :destinationable,
              :created_at, :state, :user_id, :source_location_id, :des_location_id, :remark]
  def_delegators :@delivery, *Delegators

  def initialize(delivery_lc)
    @delivery = delivery_lc
    self.delegators = Delegators
  end

  def delivery_date
    dispatch = @delivery.get_record('dispatch')
    dispatch.nil? ? '' : dispatch.impl_time.localtime.strftime('%Y.%m.%d %H:%M')
  end

  def received_date
    receive = @delivery.get_record('receive')
    receive.nil? ? '' : receive.impl_time.localtime.strftime('%Y.%m.%d %H:%M')
  end

  def received_user
    receive = @delivery.get_record('receive')
    receive.nil? ? '' : receive.impl_id
  end

  def created_at
    @delivery.created_at.nil? ? '' : @delivery.created_at.localtime.strftime('%Y-%m-%d %H:%M:%S')
  end

  def forklifts
    LogisticsContainerService.get_forklifts(@delivery)
  end

  def user
    User.find_by_id(self.user_id)
  end

  def state_display
    MovableState.display(self.state)
  end

  def to_json
    {
        id: self.id,
        cotainer_id:self.container_id,
        delivery_date: self.delivery_date,
        received_date: self.received_date,
        state: self.state,
        state_display: self.state_display,
        can_delete: false, #notice
        user_id: self.user.id,
        user_name: self.user.name,
        source_id:self.source_location_id,
        source: @delivery.source.name,
        destination_id: self.des_location_id,
        destination: @delivery.destination.name,
        remark: self.remark
    }
  end
end