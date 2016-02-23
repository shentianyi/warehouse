class Tenant < ActiveRecord::Base
  self.inheritance_column = nil
  has_many :locations

  scope :clients, -> { where(type: TenantType::CLIENT) }
end
