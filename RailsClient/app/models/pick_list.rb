class PickList < ActiveRecord::Base
  include Extensions::UUID
  include LedStateable
  belongs_to :user
  has_many :pick_items
  belongs_to :whouse

  has_many :pick_orders,:dependent => :destroy
  has_many :orders, through: :pick_orders, :dependent => :destroy

  def generate_id
    "P#{Time.now.to_milli}"
  end

  def self.by_order_car order_car
    PickList.joins(:orders).
        where(orders: {orderable_id: order_car.id, orderable_type: order_car.class.name})
        .order(id: :desc).first
  end
end
