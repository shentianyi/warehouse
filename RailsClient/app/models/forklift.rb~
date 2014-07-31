class Forklift < ActiveRecord::Base
  include Extensions::UUID
  include Extensions::STATE

  belongs_to :delivery
  belongs_to :whouse
  has_many :state_logs, as: :stateable
  #has_many :forklift_items, :dependent => :destroy
  has_many :packages #, :through => :forklift_items
  #delegate :delivery ,:to => :packages
  belongs_to :user
  belongs_to :stocker, class_name: "User"

  #add_to_delivery
  def add_to_delivery delivery_id
    self.sum_packages = self.packages.count
    self.delivery_id = delivery_id
    self.save
  end

  def package_checked
    self.accepted_packages = self.accepted_packages + 1
    self.save
  end

  def package_unchecked
    self.accepted_packages = self.accepted_packages - 1
    self.save
  end

  #remove_from_delivery
  def remove_from_delivery
    self.delivery = nil
    self.save
  end

  def generate_id
    "F#{Time.now.to_milli}"
  end
end
