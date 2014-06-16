class ForkliftPresenter<Presenter
  def_delegators :@forklift,:id,:whouse_id,:created_at,:user_id,:stocker_id,:state

  def initialize(forklift)
    @forklift=forklift
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

  def to_json
    {
        id: self.id,
        created_at:self.create_time,
        user_id:self.creator,
        stocker_id:self.stockman,
        whouse_id:self.whouse_name
    }
  end
end