class ForkliftPresenter<Presenter
  Delegators=[:id,:whouse_id,:created_at,:user,:stocker,:state,:packages,:user_id,:stocker_id,:whouse,:sum_packages,:accepted_packages]
  def_delegators :@forklift,*Delegators

  def initialize(forklift)
    @forklift=forklift
    self.delegators = Delegators
  end

  def whouse_name
    if self.whouse
      self.whouse.name
    else
      ''
    end
  end

  def create_time
    ''
  end

  def creator
    if self.user
      self.user_id
    else
      ''
    end
  end

  def stockman
    if self.stocker
      self.stocker_id
    else
      ''
    end
  end

  def all_packages
    packages = []
    pp = PackagePresenter.init_presenters(self.packages)
    pp.each do |p|
      packages << p.to_json
    end
    packages
  end

  def to_json
    {
        id: self.id,
        created_at:self.create_time,
        user_id:self.creator,
        stocker_id:self.stockman,
        whouse_id:self.whouse_name,
        sum_packages:self.sum_packages,
        accepted_packages:self.accepted_packages
    }
  end

  def to_json_with_packages
    {
        id: self.id,
        created_at:self.create_time,
        user_id:self.creator,
        stocker_id:self.stockman,
        whouse_id:self.whouse_name,
        sum_packages:self.sum_packages,
        accepted_packages:self.accepted_packages,
        packages:self.all_packages
    }
  end
end