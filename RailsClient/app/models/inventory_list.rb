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
      if w=Whouse.find_by(nr: i.whouse_id)
        if !(ps = w.positions).blank?
          return !ps.pluck(:nr).include?(position)
        end
      end
    end

    true
  end

end
