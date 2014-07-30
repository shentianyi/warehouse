class PickItem < ActiveRecord::Base
  include Extensions::UUID
  belongs_to :pick_list
  belongs_to :destination_whouse,class_name:'Whouse',foreign_key:'destination_whouse_id'

  def generate_id
    "PI#{Time.now.to_milli}"
  end
end
