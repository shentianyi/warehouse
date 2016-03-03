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

  def self.to_xlsx parts
    p = Axlsx::Package.new

    wb = p.workbook
    wb.add_worksheet(:name => "sheet1") do |sheet|
      sheet.add_row ["序号", "ID", "名称", "零件类型", "客户号", "单位包装量", "盘点单位转换标准", "截面", "重量",	 "重量误差"]
      parts.each_with_index { |part, index|

        sheet.add_row [
                          index+1,
                          part.id,
                          part.name,
                          part.part_type.blank? ? '' : part.part_type.id,
                          part.customernum,
                          part.unit_pack,
                          part.convert_unit,
                          part.cross_section,
                          part.weight,
                          part.weight_range
                      ]
      }
    end
    p.to_stream.read
  end
end