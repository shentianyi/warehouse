class Storage<ActiveRecord::Base
  include Extensions::UUID
  belongs_to :storable, polymorphic: true
  belongs_to :part
end