class StateLog < ActiveRecord::Base
  include Extension::UUID

  belongs_to :stateable, polymorphic: true
end
