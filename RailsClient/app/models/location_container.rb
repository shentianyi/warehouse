class LocationContainer < ActiveRecord::Base
  include Extensions::UUID
  belongs_to :containerable, :polymorphic => true
  belongs_to :location
end