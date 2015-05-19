class PickItem < ActiveRecord::Base
  include Extensions::UUID
  belongs_to :pick_list
  belongs_to :destination_whouse,class_name:'Whouse',foreign_key:'destination_whouse_id'
  belongs_to :order_item

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
end
