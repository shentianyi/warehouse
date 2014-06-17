class PackagePresenter<Presenter
  def_delegators :@package,:id,:part_id,:quantity,:quantity_str,:check_in_time,:user_id,:location_id,:state,:package_position,:position

  def initialize(package)
    @package = package
  end

  def position_nr
    if self.position
      self.position.detail
    else
      ''
    end
  end

  def to_json
    {
        id: self.id,
        quantity_str: self.quantity_str,
        part_id:self.part_id,
        quantity:self.quantity,
        check_in_time:self.check_in_time,
        user_id:self.user_id,
        state:self.state,
        state_display:PackageState.display(self.state),
        position_nr:self.position_nr
    }
  end
end