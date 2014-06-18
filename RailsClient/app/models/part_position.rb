class PartPosition < ActiveRecord::Base
  include Extensions::UUID
  belongs_to :position
  belongs_to :part

  FK=[:position_id, :part_id]

end
