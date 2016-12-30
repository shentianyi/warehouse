class OrderBox < ActiveRecord::Base
  belongs_to :part
  belongs_to :order_box_type
  belongs_to :whouse
  belongs_to :source_whouse, class_name: 'Whouse'
  belongs_to :position
  has_one :led

  has_many :order_items, :as => :orderable, :dependent => :destroy

  before_save :set_default_position

  validates_presence_of :nr, :message => "料盒编号不能为空!"
  validates_uniqueness_of :nr, :message => "料盒编号不能重复!"
  validates_presence_of :position_id, :message => "料盒所属库位号不能为空!"

  def can_move_store?
    self.status==OrderBoxStatus::PICKED || (self.status==OrderBoxStatus::PICKING && self.order_box_type && Setting.not_need_weight_box_type_values.include?(self.order_box_type.name))
  end

  def set_default_position
    if self.position.blank?
      if p=self.whouse.positions.first
        self.position=p
      end
    end
  end

  def self.to_xlsx order_boxes
    p = Axlsx::Package.new

    wb = p.workbook
    wb.add_worksheet(:name => "sheet1") do |sheet|
      sheet.add_row ["序号", "编码", "RFID编号", "状态",	"零件号",	"数量",	"要货仓库号",	"出货仓库号",	"料盒类型",	"库位号"]
      order_boxes.each_with_index { |order_box, index|
        sheet.add_row [
                          index+1,
                          order_box.nr,
                          order_box.rfid_nr,
                          OrderBoxStatus.display(order_box.status),
                          order_box.part.blank? ? '' : order_box.part.id,
                          order_box.quantity,
                          order_box.warehouse.blank? ? '' : order_box.warehouse.id,
                          order_box.source_warehouse.blank? ? '' : order_box.source_warehouse.id,
                          order_box.order_box_type.blank? ? '' : order_box.order_box_type.name,
                          order_box.position.blank? ? '' : order_box.position.id
                      ]
      }
    end
    p.to_stream.read
  end
end
