class NStorage < ActiveRecord::Base
  belongs_to :ware_house, class_name: 'WareHouse'

  def whId
    ware_house and ware_house.whId or nil
  end
end
