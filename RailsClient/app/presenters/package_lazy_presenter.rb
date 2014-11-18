class PackageLazyPresenter<Presenter
  Delegators=[:id,:container_id,:user_id,:state, :container]
  def_delegators :@logistics_container, *Delegators

  def initialize(logistics_container)
    @logistics_container=logistics_container
    @package=logistics_container.package
    self.delegators = Delegators
  end

  def position_nr
    ''
  end

  def to_json
    {
        id: self.id,
        container_id:self.container_id,
        quantity_str: PackageLabelRegex.quantity_prefix_string+@package.custom_quantity,
        part_id: PackageLabelRegex.part_prefix_string+@package.part_id,
        quantity: @package.quantity,
        check_in_time: PackageLabelRegex.date_prefix_string+@package.custom_fifo_time,
        user_id: self.user_id,
        state: self.state,
        state_display: PackageState.display(self.state),
        position_nr: self.position_nr
    }
  end

  def to_json_simple
    {
        id: self.id,
        container_id:self.container_id,
        quantity_str: PackageLabelRegex.quantity_prefix_string+@package.custom_quantity,
        part_id: PackageLabelRegex.part_prefix_string+@package.part_id,
        quantity: @package.quantity,
        check_in_time: PackageLabelRegex.date_prefix_string+@package.custom_fifo_time,
        user_id: self.user_id,
        state: self.state,
        state_display: '',
        position_nr: ''
    }
  end
end