class LocationContainer < ActiveRecord::Base
  include Extensions::UUID
  include Movable

  belongs_to :container
  belongs_to :current_positionable,polymorphic: true
  belongs_to :sourceable,polymorphic: true
  belongs_to :desitinationalbe,polymorphic: true

  belongs_to :location

  has_many :movable_records, :as => :movable

end