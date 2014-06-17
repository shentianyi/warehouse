class Position < ActiveRecord::Base
  include Extensions::UUID

  belongs_to :whouse, :dependent => :destroy
end
