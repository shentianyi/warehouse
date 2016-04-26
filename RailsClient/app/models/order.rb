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

  #before_save :set_required_at

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

  # def set_required_at
  #   if self.required_at.present?
  #     self.required_at=(self.required_at).localtime.utc
  #   end
  # end

  def batch_nr
    self.required_at.present? ? self.required_at.localtime.strftime('%y%m%d%H') : ''
  end

  def required_at_display
    self.required_at.blank? ? '' : self.required_at.localtime.strftime('%Y-%m-%d %H:%M')
  end

  def self.to_xlsx orders
    p = Axlsx::Package.new
    wb = p.workbook

    orders.each do |order|
      wb.add_worksheet(:name => order.id) do |sheet|
        sheet.add_row ["订单号", "报缺时间", "要货员", "要货地", "备货地", "是否紧急需求", "创建时间", "是否已处理", "订单项目号", "零件号", "箱数", "状态"]

        if items = order.order_items
          #sheet.add_row ["订单项目列表", "订单项目号", "零件号", "箱数", "数量", "状态"]
          items.each_with_index do |item, index|
            sheet.add_row [
                              order.id,
                              order.required_at_display,
                              order.user.nil? ? nil : order.user.name,
                              order.source_location.blank? ? '' : order.source_location.name,
                              order.source.blank? ? '' : order.source.name,
                              order.is_emergency ? "是" : "否",
                              order.created_at.localtime.strftime('%Y-%m-%d %H:%M'),
                              order.handled ? "是" : "否",
                              item.id,
                              item.part.nr,
                              item.quantity,
                              OrderItemState.display(item.state)
                          ]
          end
        end

      end
    end

    p.to_stream.read
  end
end
