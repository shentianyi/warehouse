class PickItem < ActiveRecord::Base
  include Extensions::UUID
  belongs_to :pick_list
  # belongs_to :destination_whouse, class_name: 'Whouse', foreign_key: 'destination_whouse_id'
  belongs_to :order_item
  belongs_to :order_user, class_name: 'User', foreign_key: :user_id
  belongs_to :part

  def generate_id
    "PI#{Time.now.to_milli}"
  end

  def remark
    if self.order_item
      self.order_item.remark
    end
  end

  def is_out_of_stock
    if self.order_item
      self.order_item.out_of_stock
    end
  end

  def is_emergency
    if self.order_item
      self.order_item.is_emergency
    end
  end

  def is_finished
    if self.order_item
      self.order_item.is_finished
    end
  end

  def source_location
    @source_location||= self.order_item.order.source_location
  end

  def self.to_total_xlsx pick_items
    p = Axlsx::Package.new
    wb = p.workbook
    wb.add_worksheet(:name => "sheet1") do |sheet|
      sheet.add_row ["序号", "择货单号", "零件号", "数量", "箱数", "要货员工号", "要货项目", "要货库位", "是否加急", "备注"]
      pick_items.each_with_index { |pick_item, index|
        pp = OrderItemService.verify_department(pick_item.destination_whouse_id, pick_item.part_id)
        sheet.add_row [
                          index+1,
                          pick_item.pick_list_id,
                          pick_item.part_id,
                          pick_item.quantity,
                          pick_item.box_quantity,
                          pick_item.user_id,
                          pick_item.destination_whouse.name,
                          pp.blank? ? '' : pp.position.detail,
                          pick_item.is_emergency ? '是' : '否',
                          pick_item.remark
                      ]
      }
    end
    p.to_stream.read
  end

end
