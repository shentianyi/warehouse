class PackagePresenter<Presenter
  Delegators=[:id, :container_id, :user_id, :whouse_id, :state, :part_id, :quantity, :fifo_time, :custom_quantity, :custom_fifo_time]
  def_delegators :@package, *Delegators

  def initialize(package)
    @package=package
    self.delegators = Delegators
  end


  def self.init_json_presenters params,with_position=true
    params.map{|param| self.new(param).to_json(with_position)}
  end

  def position_nr
    if position=PartService.get_position_by_whouse_id(self.part_id, self.whouse_id)
      position.detail
    else
      ''
    end
  end

  def to_json(with_position=true)
    {
        id: self.id,
        container_id: self.container_id,
        quantity_str: PackageLabelRegex.quantity_prefix_string+self.custom_quantity,
        part_id: PackageLabelRegex.part_prefix_string+self.part_id,
        quantity: self.quantity,
        check_in_time: PackageLabelRegex.date_prefix_string+self.custom_fifo_time,
        user_id: self.user_id,
        state: self.state,
        state_display: PackageState.display(self.state),
        position_nr: with_position ? self.position_nr : ''
    }
  end
end