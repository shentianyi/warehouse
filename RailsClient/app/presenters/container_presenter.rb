class ContainerPresenter<Presenter
  Delegators=[:id, :part_id, :quantity, :custom_fifo_time, :user_id, :location_id, :state]
  def_delegators :@container, *Delegators

  def initialize(container)
    @container = container
    self.delegators = Delegators
  end
end