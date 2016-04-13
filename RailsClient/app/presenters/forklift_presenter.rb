class ForkliftPresenter<Presenter
  Delegators=[:id, :container_id, :destinationable_id, :destinationable, :created_at, :state, :user, :user_id, :children, :descendants]
  def_delegators :@forklift, *Delegators

  def initialize(forklift_lc)
    @forklift=forklift_lc
    self.delegators = Delegators
  end

  def destinationable_nr
    @forklift.destinationable.nil? ? '' : @forklift.destinationable.nr
  end

  def created_at
    @forklift.created_at.blank? ? '' : @forklift.created_at.localtime.strftime('%Y-%m-%d %H:%M')
  end

  def user_id
    @forklift.user.blank? ? '' : @forklift.user.nr
  end

  def sum_packages
    LogisticsContainerService.count_all_packages(@forklift)
  end

  def accepted_packages
    LogisticsContainerService.count_accepted_packages(@forklift)
  end

  def all_packages
    #PackagePresenter.init_json_presenters(LogisticsContainerService.get_all_packages_with_detail(self))
  end

  def packages
    LogisticsContainerService.get_packages(@forklift)
  end


  # def stocker_nr
  #   self.stocker.present? ? self.stocker.nr : ''
  # end

  def to_json
    {
        id: self.id,
        container_id: self.container_id,
        created_at: self.created_at,
        user_id: self.user_id,
        stocker_id: self.user_id,
        whouse_id: self.destinationable_nr,
        sum_packages: self.sum_packages,
        accepted_packages: self.accepted_packages,
        state: self.state,
        state_display: @forklift.state_display
    }
  end

=begin
  def to_json_with_packages
    {
        id: self.id,
        container_id: self.container_id,
        created_at: self.created_at,
        user_id: self.user_id,
        stocker_id: self.user_id,
        whouse_id: self.destinationable_name,
        sum_packages: LogisticsContainerService.count_all_packages(self),
        accepted_packages: LogisticsContainerService.count_accepted_packages(self),
        packages: self.all_packages
    }
  end
=end
end