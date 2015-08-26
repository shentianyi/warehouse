class Position < ActiveRecord::Base
  include Extensions::UUID

  belongs_to :whouse
  has_many :part_positions, :dependent => :destroy
  has_many :parts, :through => :part_positions
  has_one :led, -> {where is_valid: true}

  include Import::PositionCsv

  # has_many :inventory_list_items
  validate :validate_save

  def display
    "#{self.whouse.name} => #{self.detail}"
  end

  def validate_save
    errors.add(:id, '编号不可为空') if self.id.blank?
  end

  def generate_id
    "PS#{Time.now.to_milli}"
  end

  def default_part
    self.parts.first
  end

  def self.trans_position
    t= Time.now
    h = t.strftime("%H").to_i
    if h >= 19 && h < 7
      t.strftime("%m %d 00")
    else
      t.strftime("%m %d 01")
    end
  end
end
