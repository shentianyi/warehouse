module Old
  class OPackage < ActiveRecord::Base
    belongs_to :user
    belongs_to :forklift

    include Extensions::UUID
    self.table_name = "packages"
  end
end