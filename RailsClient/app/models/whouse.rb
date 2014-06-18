class Whouse < ActiveRecord::Base
  include Extensions::UUID

  belongs_to :location
  has_many :positions, :dependent => :destroy
end
