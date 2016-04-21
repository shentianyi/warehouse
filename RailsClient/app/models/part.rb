class Part < ActiveRecord::Base
  include Extensions::UUID
  include Import::PartCsv
  validates_presence_of :nr, :message => "nr不能为空!"
  validates_uniqueness_of :nr, :message => "nr不能重复!"

  belongs_to :user
  belongs_to :part_type
  has_many :part_positions, :dependent => :destroy
  has_many :positions, :through => :part_positions
  has_many :whouses, :through => :positions
  has_many :packages
  has_many :storages
  belongs_to :package_type

  has_many :part_clients

  has_many :containers
  #has_many :inventory_list_items

  def package_name
    self.package_type.blank? ? '' : self.package_type.name
  end

  def type_name
    self.part_type.blank? ? '' : self.part_type.name
  end

  def self.exists?(nr)
    Part.find_by_nr(nr)
  end

  def is_wire?
    self.part_type_id=='Wire'
  end

  def self.nr_by_regex(nr)
    nr.sub(/^P/, '')
  end

  def package_type_is_wooden?
    self.package_type.nr=='wooden'
  end

  def package_type_is_box?
    self.package_type.nr=='box'
  end

  def default_position wh
    position = self.positions.where(whouse_id: wh).first
    if position
      default_position = position.detail
    else
      " "
    end
  end

  def nr_for_user(user)
    tenant= user.location.tenant
    if tenant.type==LocationType::CLIENT
      if cpart=tenant.parts.find_by_part_id(self.id)
        cpart.client_part_nr
      end
    else
      self.nr
    end
  end

  def self.find_by_for_user(user, nr)
    tenant= user.location.tenant
    if tenant.type==LocationType::CLIENT
      if cpart=tenant.parts.find_by_client_part_nr(nr)
        cpart.part
      end
    else
      self.find_by_nr(nr)
    end
  end
end