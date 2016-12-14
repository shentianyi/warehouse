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

  def self.options
    self.all.map { |r| [r.detail, r.id] }
  end

  def self.to_xlsx positions
    p = Axlsx::Package.new

    wb = p.workbook
    wb.add_worksheet(:name => "sheet1") do |sheet|
      sheet.add_row ["序号", "编码", "名称", "描述", "所属仓库"]
      positions.each_with_index { |position, index|
        warehouse=Warehouse.find_by_id(position.whouse_id)
        sheet.add_row [
                          index+1,
                          position.id,
                          position.detail,
                          position.description,
                          warehouse.blank? ? '' : warehouse.nr
                      ]
      }
    end
    p.to_stream.read
  end
end
