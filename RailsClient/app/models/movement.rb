class Movement < ActiveRecord::Base
  belongs_to :type, class_name: 'MoveType'
  belongs_to :to, class_name: 'Whouse'
  belongs_to :from, class_name: 'Whouse'
end
