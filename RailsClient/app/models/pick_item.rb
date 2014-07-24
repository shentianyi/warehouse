class PickItem < ActiveRecord::Base
  include Extensions::UUID
  belongs_to :pick_list
end
