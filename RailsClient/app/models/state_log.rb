class StateLog < ActiveRecord::Base
  include Extensions::UUID

  belongs_to :stateable, polymorphic: true

  FK=%w(id)
end
