class Storage<ActiveRecord::Base
  include Extensions::UUID
  belongs_to :storable, polymorphic: true

end