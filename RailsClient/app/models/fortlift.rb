class Fortlift < ActiveRecord::Base
  include Extensions::UUID

  belongs_to :delivery
end
