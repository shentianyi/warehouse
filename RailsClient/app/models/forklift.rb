class Forklift < ActiveRecord::Base
  include Extensions::UUID
  include Extensions::STATE

  belongs_to :delivery
  has_many :state_logs, as: :stateable
  has_many :forklift_items, :dependent => :destroy
  has_many :packages, :through => :forklift_items
  belongs_to :user
  belongs_to :stocker, class_name: "User"

  #-------------
  # class methods
  #-------------
  #get all avaliable forklifts
  def self.avaliable!
    where('delivery_id is NULL')
  end

  #-------------
  # instance methods
  #------------
  #add a package
  def add_package package
    unless packages.nil?
      false
    end
    package.add_to_forklift self.id
  end

  #remove a package
  def remove_package package
    if package
      package.remove_from_forklift
    end
  end

  #remove all packages
  def remove_all_packages
    packages.all do |p|
      remove_package(p.id)
    end
  end

  #add_to_delivery
  def add_to_delivery delivery_id
    self.delivery_id = delivery_id
    self.save
  end

  #remove_from_delivery
  def remove_from_delivery
    self.delivery_id = nil
    self.save
  end
end
