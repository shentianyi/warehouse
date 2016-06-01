class Position < ActiveRecord::Base
  include Extensions::UUID
  include Import::PositionCsv
  validates_presence_of :nr, :message => "nr不能为空!"
  validates_uniqueness_of :nr, :message => "nr不能重复!"
  belongs_to :whouse
  has_many :part_positions, :dependent => :destroy
  has_many :parts, :through => :part_positions
  # has_many :inventory_list_items
  # validate :validate_save

  def display
    "#{self.whouse.name} => #{self.nr}"
  end

  # def validate_save
  #   errors.add(:id, '编号不可为空') if self.id.blank?
  # end
  #
  # def generate_id
  #   "PS#{Time.now.to_milli}"
  # end

  # def self.trans_position
  #   t= Time.now
  #   h = t.strftime("%H").to_i
  #   if h >= 19 && h < 7
  #     t.strftime("%m %d 00")
  #   else
  #     t.strftime("%m %d 01")
  #   end
  # end
p=[]
  p.inject

  def check_position_capacity move_count, position_capacity
    msg = Message.new()

    movement_source_stock=MovementSource.processing_count_by_position(self.id)
    nstorage_stock=NStorage.where(position_id: self.id).size

    if position_capacity < (movement_source_stock + nstorage_stock + move_count)
      msg.result = false
      msg.content = "该库位：#{self.nr}已有库存：#{nstorage_stock}件, 未完成移库单中：#{movement_source_stock}件, 本次将移入：#{move_count}件, 超过最大容量"
    end
    msg.result = true
    msg
  end
end
