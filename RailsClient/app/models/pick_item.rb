class PickItem < ActiveRecord::Base
  include Extensions::UUID
  belongs_to :pick_list
  belongs_to :destination_whouse, class_name: 'Whouse', foreign_key: 'destination_whouse_id'
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

    wh_ids=[]
    if user=User.find_by_id(self.user_id)
      LocationDestination.where(destination_id: user.location.id).each do |ld|
        wh_ids+=ld.location.whouses.pluck(:id)
      end
    end

    storages=NStorage.select("SUM(n_storages.qty) as total_qty, n_storages.position").where(partNr: self.part_id, ware_house_id: wh_ids.uniq).group(:position)
    # storages=NStorage.select("SUM(n_storages.qty) as total_qty, n_storages.position").where(partNr: self.part_id, ware_house_id: wh_ids.uniq-[self.destination_whouse_id]).group(:position)
    storages.each do |storage|
      pick_storages<<"#{storage.position.blank? ? "库位没有记录" : storage.position}/#{storage.total_qty}"
    end

    pick_storages.join("-----")
  end

  def pick_info pick_user
    pick_storages=[]

    pick_item_wh_ids=[]
    pick_user_wh_ids=[]

    if pick_user
      pick_user_wh_ids=pick_user.location.whouses.pluck(:id)
    end
    if self.destination_whouse && self.destination_whouse.location
      LocationDestination.where(destination_id: self.destination_whouse.location.id).each do |ld|
        pick_item_wh_ids+=ld.location.whouses.pluck(:id)
      end
    end

    if (pick_item_wh_ids&pick_user_wh_ids).size>0
      storages=NStorage.where(partNr: self.part_id, ware_house_id: pick_item_wh_ids&pick_user_wh_ids)
      storages.each do |storage|
        #pick_storages<<"(#{storage.packageId}/#{storage.position})"
        pick_storages<<{
            part_id: storage.partNr,
            package_id: storage.packageId.blank? ? '' : storage.packageId,
            position: storage.position.blank? ? '' : storage.position,
            pick_item_id: self.id
        }
      end
    end

    pick_storages
  end
end
