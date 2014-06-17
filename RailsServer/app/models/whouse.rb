class Whouse < ActiveRecord::Base
  include Extensions::UUID

  belongs_to :location, :dependent => :destroy
end
