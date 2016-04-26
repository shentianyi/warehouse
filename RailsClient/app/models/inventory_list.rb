class InventoryList < ActiveRecord::Base
  belongs_to :user
  belongs_to :whouse
  has_many :inventory_list_items, dependent: :destroy
  validates :name, presence: true
  validates :state, presence: true


  def has_unlocked_pack_item
    self.inventory_list_items.where(locked: false).where("package_id<>''").count>0
  end

  def has_locked_pack_item
    self.inventory_list_items.where(locked: true).where("package_id<>''").count>0
  end

  def has_stored_item
    self.inventory_list_items.where(in_stored: true).count>0
  end

  def has_un_stored_item
    self.inventory_list_items.where(in_stored: false).count>0
  end

  def self.validate_position(id, position)
    if i=InventoryList.find_by(id: id)
      if w=Whouse.find_by(id: i.whouse_id)
        if !(ps = w.positions).blank?
          return !ps.pluck(:nr).include?(position)
        end
      end
    end

    true
  end

  def self.position_ids(id, nr)
    if i=InventoryList.find_by(id: id)
      if w=Whouse.find_by(id: i.whouse_id)
        w.positions.where("nr like '%#{nr}%'").pluck(:id)
      end
    end
  end

  # generate report
  def generate_qty_discrepancy_report
    results = []
    storages = NStorage.joins('inner join parts on parts.id=n_storages.partNr').
        where(ware_house_id: self.whouse_id)
                   .select("partNr,parts.nr as nr, sum(qty) as qty,count(*) as num")
                   .group('partNr')

    inventory_list_items = self.inventory_list_items.joins(:part)
                               .select("part_id,parts.nr as nr, sum(qty) as qty2,count(*) as num")
                               .group("part_id")

    storages.each do |storage|
      # puts "#{storage.partNr}"
      # 零件号:0,库存数量:1,盘点数量:2,数量差异值:3,库存桶数:4,盘点桶数:5,桶数差异:6
      results.push([storage.nr, storage.qty, 0, storage.qty, storage.num, 0, storage.num])
    end

    inventory_list_items.each do |inventory_list_item|
      flag = false
      results.each do |result|
        # @storages.each do |storage|
        if inventory_list_item.nr == result[0]
          result[2]=inventory_list_item.qty2
          result[3] = (result[1]||0) - result[2]
          result[5]=inventory_list_item.num
          result[6]= (result[4]||0) - result[5]
          flag = true
        end
      end
      if !flag
        results.push([Part.find_by_id(inventory_list_item.part_id).nr, 0, inventory_list_item.qty2, 0-inventory_list_item.qty2.to_f, 0, inventory_list_item.num, 0-inventory_list_item.num])
      end
    end
    results
  end

  def generate_pack_discrepancy_report
    storages = NStorage.joins(:position).joins('inner join parts on parts.id=n_storages.partNr').
        where(ware_house_id: self.whouse_id)
                   .select("packageId as package_id,partNr as part_id,parts.nr as nr,position_id,positions.nr as positions_nr")

    inventory_list_items = self.inventory_list_items.joins(:position_object).joins(:part)
                               .select("package_id,part_id,parts.nr as nr,position as position_id, positions.nr as positions_nr")


    results={}

    storages.each do |storage|
      results[storage.package_id]={
          package_id: storage.package_id,
          part_id: storage.part_id,
          part_nr: storage.nr,
          stock_position_id: storage.position_id,
          stock_position_nr: storage.positions_nr,
          inven_position_id: nil,
          inven_position_nr: nil,
          same_position: false
      }
    end

    inventory_list_items.each do |item|

      if results[item.package_id].present?
        results[item.package_id][:inven_position_id]=item.position_id
        results[item.package_id][:inven_position_nr]=item.positions_nr
        results[item.package_id][:same_position]=(item.position_id==results[item.package_id][:stock_position_id])
      else
        results[item.package_id]={
            package_id: item.package_id,
            part_id: item.part_id,
            part_nr: item.nr,
            stock_position_id: nil,
            stock_position_nr: nil,
            inven_position_id: item.position_id,
            inven_position_nr: item.positions_nr,
            same_position: false
        }
      end
    end
    results
  end

  def self.bool_display(bool)
    bool ? 'Y' : 'N'
  end
end
