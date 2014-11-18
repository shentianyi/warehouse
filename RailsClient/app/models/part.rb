class Part < ActiveRecord::Base
  include Extensions::UUID
  include Import::PartCsv

  belongs_to :user
  belongs_to :part_type
  has_many :part_positions, :dependent => :destroy
  has_many :positions, :through => :part_positions
  has_many :whouses,:through => :positions
  has_many :packages

  has_many :containers

  def self.exists?(id)
   !Part.find_by_id(id).nil?
  end
end
