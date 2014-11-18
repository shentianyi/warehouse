class LogisticsContainer<LocationContainer
  include CZ::Movable

  default_scope { where(type: LocationContainerType::LOGISTICS) }
  has_ancestry
  belongs_to :destinationable, polymorphic: true
  belongs_to :source_location, class_name: 'Location'
  belongs_to :des_location, class_name: 'Location'
  belongs_to :package, foreign_key: :container_id
  belongs_to :forklift, foreign_key: :container_id
  belongs_to :delivery, foreign_key: :container_id
  has_many :records, :as => :recordable

  def exists?(location_id)
    self.source_location_id==location_id
  end

  def self.build(container_id, user_id, location_id)
    old_lc=self.find_latest_by_container_id(container_id)
    unless old_lc.nil? || old_lc.exists?(location_id)
      new_lc=self.create(container_id: container_id, user_id: user_id, source_location_id: location_id)
      old_lc.rebuild_to_location(user_id, location_id, new_lc)
      return new_lc
    end
    return old_lc
  end

  def rebuild_to_location(user_id, location_id, parent)
    self.children.each do |lc|
      new_lc=self.class.find_latest_by_container_id(lc.container_id)
      unless new_lc.exists?(location_id)
        new_lc=self.class.create(container_id: lc.container_id, user_id: user_id, source_location_id: location_id)
      end
      if new_lc.root?
        parent.add(new_lc)
        lc.rebuild_to_location(user_id, location_id, new_lc)
      end
    end
  end


  def self.find_latest_by_container_id(container_id)
    where(container_id: container_id).order(created_at: :desc).first
  end

  def self.find_latest(container_id, location_id)
    where(container_id: container_id, source_location_id: location_id, state: INIT).order(created_at: :desc).first
  end

  def self.are_roots?(container_ids, location_id)
    where(container_id: container_ids, source_location_id: location_id, ancestry: nil).count==container_ids.length
  end

  def can_add_to_container?
    root?
  end
end