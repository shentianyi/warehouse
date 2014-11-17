class PackagePresenter<Presenter
  Delegators=[:id, :part_id, :quantity,:custom_quantity, :custom_fifo_time, :user_id, :location_id, :state, :package_position, :position]
  def_delegators :@package, *Delegators

  def initialize(package)
    @package = package
    self.delegators = Delegators
  end

  def position_nr
    # if self.position
    #   self.position.detail
    # else
    #   ''
    # end
    ''
  end

  def to_json
    {
        id: self.id,
        quantity_str: PackageLabelRegex.quantity_prefix_string+self.custom_quantity,
        part_id: PackageLabelRegex.part_prefix_string+self.part_id,
        quantity: self.quantity,
        check_in_time: PackageLabelRegex.date_prefix_string+self.custom_fifo_time,
        user_id: self.user_id,
        state: self.state,
        state_display: PackageState.display(self.state),
        position_nr: self.position_nr
    }
  end

  def to_json_simple
    {
        id: self.id,
        quantity_str: PackageLabelRegex.quantity_prefix_string+self.custom_quantity,
        part_id: PackageLabelRegex.part_prefix_string+self.part_id,
        quantity: self.quantity,
        check_in_time: PackageLabelRegex.date_prefix_string+self.custom_fifo_time,
        user_id: self.user_id,
        state: self.state,
        state_display: '',
        position_nr: ''
    }
  end
end