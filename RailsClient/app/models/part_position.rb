class PartPosition < ActiveRecord::Base
  include Extensions::UUID
  include Import::PartPositionCsv
  belongs_to :position
  belongs_to :part

  belongs_to :sourceable, polymorphic: true

  FK=%w(position_id part_id)

end
