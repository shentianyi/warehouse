class LocationContainer < ActiveRecord::Base
  include Extensions::UUID
  include Movable

  has_many :movable_records, as: :movable
  belongs_to :containerable, :polymorphic => true
  belongs_to :location
end