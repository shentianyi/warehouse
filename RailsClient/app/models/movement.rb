class Movement < ActiveRecord::Base
  belongs_to :type, class_name: 'MoveType'
end
