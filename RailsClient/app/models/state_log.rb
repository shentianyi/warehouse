class StateLog < ActiveRecord::Base
  include Extensions::UUID

  belongs_to :stateable, polymorphic: true

  FK=[:stateable_id, :stateable_type]
end
