class Modem < ActiveRecord::Base
  include Extensions::UUID
  include Import::ModemCsv
end
