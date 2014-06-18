class Position < ActiveRecord::Base
  include Extensions::UUID

  belongs_to :whouse
  has_many :part_positions, :dependent => :destroy
end
