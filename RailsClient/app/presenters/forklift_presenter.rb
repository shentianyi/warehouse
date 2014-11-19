class ForkliftPresenter<Presenter
  Delegators=[:id, :container_id, :destinationable_id, :destinationable, :created_at, :state, :user_id, :children]
  def_delegators :@forklift, *Delegators

  def initialize(forklift_lc)
    @forklift=forklift_lc
    self.delegators = Delegators
  end

  def destinationable_name
    @forklift.destinationable.nil? ? '' : @forklift.destinationable.name
  end

  def created_at
    @forklift.created_at.blank? ? '' : @forklift.created_at.strftime("%Y-%m-%d %H:%M")
  end

  def user_id
    @forklift.user_id.blank? ? '' : @forklift.user_id
  end

  def sum_packages
    #@forklift.sum_packages
    @forklift.children.count
  end

  def accepted_packages
    #@forklift.accepted_packages
    @forklift.children.select{|c| c.state == MovableState::CHECKED}.count
  end

  def all_packages
    PackagePresenter.init_json_presenters(ForkliftService.get_packages_with_detail(self))
  end

  def to_json
    {
        id: self.id,
        container_id: self.container_id,
        created_at: self.created_at,
        user_id: self.user_id,
        stocker_id: self.user_id,
        whouse_id: self.destinationable_name,
        sum_packages: ForkliftService.count_all_packages(self),
        accepted_packages: ForkliftService.count_accepted_packages(self)
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
        sum_packages: ForkliftService.count_all_packages(self),
        accepted_packages: ForkliftService.count_accepted_packages(self),
        packages: self.all_packages
    }
  end
=end
end