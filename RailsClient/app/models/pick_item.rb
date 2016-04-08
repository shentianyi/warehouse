class PickItem < ActiveRecord::Base
  include Extensions::UUID
  belongs_to :pick_list
  belongs_to :destination_whouse,class_name:'Whouse',foreign_key:'destination_whouse_id'
  belongs_to :order_item

  belongs_to :part
  belongs_to :position

  def generate_id
    "PI#{Time.now.to_milli}"
  end

  # def remark
  #   # if self.order_item
  #   #   self.order_item.remark
  #   # end
  # end

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

  def orderable_nr
    @orderable_nr||= (self.order_item.present? ? self.order_item.orderable_nr : '')
  end

  def order_box
    return @order_box if @order_box.present?
    @order_box=self.order_item.orderable
  end


  def can_move_store?
    self.state==PickItemStatus::PICKED || (self.state==PickItemStatus::PICKING && self.order_box.order_box_type && Setting.not_need_weight_box_type_values.include?(self.order_box.order_box_type.name))
  end

  def pick_position
    pick_storages=[]
    part = Part.find_by_id(self.part_id)

    part.positions.each do |pp|
      storages=NStorage.select("SUM(n_storages.qty) as total_qty, n_storages.position").where(position: pp.detail, partNr: self.part_id).group(:position)
      storages.each do |storage|
        pick_storages<<"#{storage.position}/#{storage.total_qty}"
      end
    end

    pick_storages.join("-----")
  end
end
