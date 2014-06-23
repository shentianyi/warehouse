class Whouse < ActiveRecord::Base
  include Extensions::UUID
  include Import::WhouseCsv

  belongs_to :location
  has_many :positions, :dependent => :destroy
end
