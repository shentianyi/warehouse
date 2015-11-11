class MovementList < ActiveRecord::Base
  has_many :movements, dependent: :destroy
end
