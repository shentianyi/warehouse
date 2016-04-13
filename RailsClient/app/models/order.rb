class Order < ActiveRecord::Base
  include Extensions::UUID

  belongs_to :user

  has_many :order_items, :dependent => :destroy
  #发货地
  belongs_to :source, class_name: "Location"
  #要货地
  belongs_to :source_location, class_name: "Location"

  has_many :location_container_orders, dependent: :destroy
  has_many :location_containers, through: :location_container_orders

  def generate_id
    "OD#{Time.now.to_milli}"
  end

  def is_emergency
    self.order_items.each { |item|
      if item.is_emergency
        return true
      end
    }
    return false
  end

  def self.to_xlsx orders
    p = Axlsx::Package.new
    wb = p.workbook

    orders.each do |order|
      wb.add_worksheet(:name => order.id) do |sheet|
        sheet.add_row ["订单号", "要货员", "要货地", "备货地", "创建时间", "是否紧急需求", "是否已处理", "是否已删除", "订单项目号", "零件号", "箱数", "数量", "状态"]

        if items = order.order_items
          #sheet.add_row ["订单项目列表", "订单项目号", "零件号", "箱数", "数量", "状态"]
          items.each_with_index do |item, index|
            sheet.add_row [
                              order.id,
                              order.user.nil? ? nil : order.user.name,
                              order.source_location.name,
                              order.source.name,
                              order.created_at.localtime.strftime('%Y-%m-%d %H:%M'),
                              order.is_emergency ? "是" : "否",
                              order.handled ? "是" : "否",
                              order.is_delete ? "是" : "否",
                              item.id,
                              OrderItemLabelRegex.part_prefix_string + item.part_id,
                              item.box_quantity,
                              OrderItemLabelRegex.quantity_prefix_string + item.quantity.to_s,
                              OrderItemState.display(item.state)
                          ]
          end
        end

      end

    end

    p.to_stream.read
  end
end
