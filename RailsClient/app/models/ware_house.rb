class WareHouse < ActiveRecord::Base
  belongs_to :location, class_name: 'NLocation'
end
