class Tenant < ActiveRecord::Base
  self.inheritance_column = nil
  has_many :locations
 
  has_many :parts, class_name:'PartClient',foreign_key: :client_tenant_id

  scope :clients, -> { where(type: TenantType::CLIENT) }
end
