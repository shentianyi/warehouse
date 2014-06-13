class Forklift < ActiveRecord::Base
  include Extensions::UUID
  include Extensions::STATE

  belongs_to :delivery
  has_many :state_logs, as: :stateable
  has_many :forklift_items, :dependent => :destroy
  has_many :packages, :through => :forklift_items
  belongs_to :user
  belongs_to :stocker, class_name: "User"

  # class methods
  #get all avaliable forklifts
  def self.avaliable!
    where('delivery_id is NULL')
  end

  # instance methods
  #add a package
  def add_package package
    unless packages.nil?
      false
    end

    package.create_forklift_item(forklift_id: self.id)
  end
end
