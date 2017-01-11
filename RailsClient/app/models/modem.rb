class Modem < ActiveRecord::Base
  include Extensions::UUID
  include Import::ModemCsv

  validates_uniqueness_of :ip
  validates :nr,  presence: true
end
