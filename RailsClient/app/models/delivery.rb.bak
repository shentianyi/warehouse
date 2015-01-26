class Delivery < ActiveRecord::Base
  include Extensions::UUID
  include Extensions::STATE

  belongs_to :users
  has_many :state_logs, as: :stateable
  has_many :forklifts
  has_many :packages, :through => :forklifts
  accepts_nested_attributes_for :forklifts
  belongs_to :user
  belongs_to :receiver, class_name: 'User'
  belongs_to :source, class_name: 'Location'
  belongs_to :destination, class_name: 'Location'
  has_many :location_containers, :as => :containerable

  #-------------
  # Class Methods
  #-------------

  #-------------
  # Instance Methods
  #-------------

  # add_forklift
  def add_forklift forklift_id
    if forklift = Forklift.find_by_id(forklift_id)
      forklift.add_to_delivery self.id
    end
  end

  # remove_forklift
  def remove_forklift forklift
    if forklift
      forklift.remove_from_delivery
    end
  end

  # remove_all_forklifts
  def remove_all_forklifts
    forklifts.all.each do |f|
      remove_forklift(f)
    end
  end

  def generate_id
    "D#{Time.now.to_milli}"
  end

  def rejected_packages
    packages.where(state: PackageState::DESTINATION)
    .select('packages.*,forklifts.whouse_id')
  end

  def received_packages
    packages.where(state: PackageState::RECEIVED)
    .select('packages.*,forklifts.whouse_id')
  end
end
