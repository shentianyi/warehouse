class PackagePresenter<Presenter
  Delegators=[:id, :container_id, :user_id, :state, :container]
  def_delegators :@logistics_container, *Delegators

  def initialize(logistics_container)
    @logistics_container=logistics_container
    @package=logistics_container.package
    self.delegators = Delegators
  end

  def position
    if @logistics_container.destinationable && @logistics_container.destinationable_type == Whouse.to_s
      if position=PartService.get_position_by_whouse_id(@package.part_id, @logistics_container.destinationable_id)
        return position
      end
    end
    nil
  end
  #需要明确，logistics_container的package的destination应该是warehouse而不是position
  def position_nr
    if self.position
      return self.position.display
    elsif @logistics_container.destinationable
      return @logistics_container.destinationable.name
    end
    ''
  end

  def part_id_display
    @package.part_id_display || ''
  end

  def quantity_display
    @package.quantity_display || ''
  end

  def fifo_time_display
    @package.fifo_time_display || ''
  end

  def created_at
    @logistics_container.created_at.blank? ? '' : @logistics_container.created_at.strftime('%Y-%m-%d %H:%M')
  end

  def destinationable_name
    @logistics_container.destinationable.nil? ? "":@logistics_container.destinationable.name
  end

  def sum_packages
    1
  end

  def possible_position
    pos = []
    self.container.part.positions.each do |ps|
      pos << {id:ps.id,display:ps.display}
    end
    pos
  end

  def to_json
    {
        id: self.id,
        container_id: self.container_id,
        quantity_display: self.quantity_display,
        part_id_display: self.part_id_display,
        quantity: @package.quantity,
        fifo_time_display: self.fifo_time_display,
        user_id: self.user_id,
        state: self.state,
        state_display: @logistics_container.state_display,
        position_nr: self.position_nr,
        possible_position:self.possible_position,
        position:self.position.nil? ? {}:{id:self.position.id,display:self.position.display}
    }
  end

  # def to_json_simple
  #   {
  #       id: self.id,
  #       container_id:self.container_id,
  #       quantity_str: PackageLabelRegex.quantity_prefix_string+@package.custom_quantity,
  #       part_id: PackageLabelRegex.part_prefix_string+@package.part_id,
  #       quantity: @package.quantity,
  #       check_in_time: PackageLabelRegex.date_prefix_string+@package.custom_fifo_time,
  #       user_id: self.user_id,
  #       state: self.state,
  #       state_display: '',
  #       position_nr: ''
  #   }
  # end
end