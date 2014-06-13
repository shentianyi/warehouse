class Package < ActiveRecord::Base
  include Extensions::UUID
  include Extensions::STATE

  has_one :forklift_item, :dependent => :destroy
  has_one :package_position
  has_one :position, :through => :package_position
  has_many :state_logs, as: :stateable

  belongs_to :user

  # when a package is added to the forklift
  # please do this
  #here is code for Leoni
  after_save :auto_shelved

  # get avaliable packages for bind
  def self.avaliable_packages
    where('id not in (select package_id from forklift_items)')
  end

  # check package id
  def self.valiade_id id
    unless Package.find_by_id(id)
      true
    else
      false
    end
  end
  #
  def add_to_forklift forklift
    self.create_forklift(forklift_id: forklift.id)
  end

  #
  def remove_from_forklift
    self.forklift_item.destroy
  end

  # set_position
  def set_position
    if self.forklift_item.nil?
      return
    end

    if pp = PartPosition.where("part_id = ? ADN whouse_name = ? ",self.part_id,self.forklift_item.forklift.whouse).first
      if self.package_position.nil?
        self.create_package_position(position_id: pp.position_id)
      else
        self.package_position.position_id = pp.position_id
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

  private
  def auto_shelved
    #if partnum changed, reset package position
    if self.part_id_changed?
      set_position
    end
  end
end
