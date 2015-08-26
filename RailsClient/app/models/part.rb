class Part < ActiveRecord::Base
  include Extensions::UUID


  belongs_to :user
  belongs_to :part_type
  has_many :part_positions, :dependent => :destroy
  has_many :positions, :through => :part_positions
  has_many :whouses, :through => :positions
  has_many :packages
  has_many :storages

  has_many :containers
  #has_many :inventory_list_items

  include Import::PartCsv


  def self.exists?(id)
    Part.find_by_id(id)
  end

  def is_wire?
    self.part_type_id=='Wire'
  end

  def self.nr_by_regex(nr)
    nr.sub(/^P/,'')
  end

  #get part's defualt position
  def self.get_default_position(whouse_id, part_id)

    unless whouse = Whouse.find_by_id(whouse_id)
      return nil
    end

    unless position = whouse.part_positions.where(part_id: part_id).first
      return nil
    end

    return position
  end
end