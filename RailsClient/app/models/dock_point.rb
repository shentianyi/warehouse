class DockPoint < ActiveRecord::Base
  has_many :positions

  validates_uniqueness_of :nr


end
