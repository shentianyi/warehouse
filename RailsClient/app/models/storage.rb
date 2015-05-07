class Storage<ActiveRecord::Base
  include Extensions::UUID
  belongs_to :storable, polymorphic: true
  belongs_to :location
  belongs_to :part

  delegate :name,prefix: true,to: :location,allow_nil: true
  delegate :name,prefix: true,to: :storable,allow_nil: true

end