module Old
  class ODelivery < ActiveRecord::Base
    include Extensions::UUID
    self.table_name = "deliveries"

    belongs_to :user
    belongs_to :destination, class_name: 'Location'
    belongs_to :receiver, class_name: 'User'
    has_many :forklifts, class_name: "OForklift", foreign_key: 'delivery_id'
  end
end