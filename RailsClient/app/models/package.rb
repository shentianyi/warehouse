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
  after_save :auto_shelved

  #-------------
  # Instance Methods
  #-------------

  # add_to_forklift
  def add_to_forklift forklift
    self.forklift = forklift
    forklift.sum_packages = forklift.sum_packages + 1
    forklift.save
#<<<<<<< HEAD
    set_position
    self.save
    #set_position
#=======
    #self.save
#    set_position
#    self.save
#>>>>>>> a0a32e3e27a1908ebc6397024f1e965812b73ae1
  end

  # remove_form_forklift
  def remove_from_forklift
    if self.forklift
      forklift.sum_packages = forklift.sum_packages - 1
      forklift.save
      self.forklift = nil
      remove_position
      self.save
    end
    true
  end

  #private
  # set_position
  def set_position
    if self.forklift_id.nil?
      return
    end

    if pp = PartPosition.joins(:position).where({part_positions: {part_id: self.part_id}, positions: {whouse_id: self.forklift.whouse_id}}).first
      if self.package_position.nil?
        self.create_package_position(position_id: pp.position_id)
      else
        self.package_position.position_id = pp.position_id
        self.package_position.is_delete = false
      end
      self.package_position.save
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
end
