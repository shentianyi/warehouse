class Package < ActiveRecord::Base
  include Extensions::UUID
  include Extensions::STATE

  #belongs_to :forklift, :throuth => :forklift_item
  #has_one :forklift_item, :dependent => :destroy
  has_one :package_position, :dependent => :destroy
  has_one :position, :through => :package_position
  has_many :state_logs, as: :stateable

  belongs_to :user
  belongs_to :location
  belongs_to :part
  belongs_to :forklift
  delegate :delivery, :to => :forklift

  # when a package is added to the forklift
  # please do this
  #here is code for Leoni
  before_save :set_package_position
  after_save :auto_shelved,:led_state_change

  #-------------
  # Instance Methods
  #-------------

  # add_to_forklift
  def add_to_forklift forklift
    self.forklift = forklift
    set_position
    self.save
  end

  # remove_form_forklift
  def remove_from_forklift
    if self.forklift
      ActiveRecord::Base.transaction do
        forklift = self.forklift
        self.forklift = nil
        remove_position
        self.save
        #forklift.sum_packages = forklift.packages.count
        #forklift.save
      end
    end
    true
  end

  #private
  # set_position
  def set_position
    if self.forklift_id.nil?
      return true
    end

    if pp = PartPosition.joins(:position).where({part_positions: {part_id: self.part_id}, positions: {whouse_id: self.forklift.whouse_id}}).first
      if self.package_position.nil?
        self.create_package_position(position_id: pp.position_id)
      else
        #self.package_position.position_id = pp.position_id
        #self.package_position.is_delete = false
        self.package_position.update({position_id:pp.position_id})
      end
      #self.package_position.save
    elsif self.package_position
      self.package_position.destroy
    else
      return true
    end
  end

  # remove_position
  def remove_position
    if self.package_position
      self.package_position.destroy
    end
  end

  def get_position
    if self.position
      self.position.detail
    else
      nil
    end
  end

  private
  def led_state_change
    if self.position.nil?
      return 
    end

    led = Led.find_by_position(self.position.detail)

    if led.nil?
      return
    end

    led_state = led.current_state
    to_state = LedLightState::NORMAL

    case self.state
      when PackageState::WAY
        to_state = LedLightState::DELIVERED
      when PackageState::RECEIVED
        to_state = LedLightState::RECEIVED
    end

    if led_state != to_state
      led.update({current_state:to_state})
    end
  end

  def auto_shelved
    #if partnum changed, reset package position
    if self.part_id_changed?
      set_position
    end
  end

  def set_package_position
    case self.state
      when PackageState::ORIGINAL
        p=self.user.location
      when PackageState::WAY
        p=Whouse.find_by_id('TransWhouse')
      when PackageState::RECEIVED
        p=self.position
    end

    if p
      self.positionable_id=p.id
      self.positionable_type=p.class.name
    end

  end

  def self.entry_report condition
    self.joins(:part).joins(forklift: :delivery)
    .where(condition)
    .select("packages.state as state,packages.part_id,COUNT(packages.id) as box_count,SUM(packages.quantity_str) as total,forklifts.whouse_id as whouse_id,deliveries.received_date as rdate,deliveries.receiver_id as receover_id")
    .group("packages.part_id,whouse_id,state").order("whouse_id,rdate DESC")
  end

  def self.removal_report condition
    self.joins(:part).joins(forklift: :delivery)
    .where(condition)
    .select("packages.state,packages.part_id,COUNT(packages.id) as box_count,SUM(packages.quantity_str) as total,forklifts.whouse_id as whouse_id,deliveries.delivery_date as ddate,deliveries.user_id as sender_id")
    .group("packages.part_id,whouse_id,state").order("whouse_id,ddate DESC")
  end
end
