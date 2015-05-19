module Old
  class OForklift < ActiveRecord::Base
    include Extensions::UUID
    self.table_name = "forklifts"

    belongs_to :user
    belongs_to :delivery
    belongs_to :whouse
    has_many :packages, class_name: "OPackage", foreign_key: 'forklift_id'
  end
end