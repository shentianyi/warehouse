class Modem < ActiveRecord::Base
  include Extensions::UUID
  include Import::ModemCsv

  validates_uniqueness_of :ip
end
