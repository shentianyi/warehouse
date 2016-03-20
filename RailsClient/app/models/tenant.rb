class Tenant < ActiveRecord::Base
  self.inheritance_column = nil

  validates_uniqueness_of :code, message: '不可重复'
  validates_presence_of :code, :message => "CODE不能为空!"
  validates_presence_of :name, :message => "名称不能为空!"

  has_many :locations
 
  has_many :parts, class_name:'PartClient',foreign_key: :client_tenant_id

  scope :clients, -> { where(type: TenantType::CLIENT) }


  def self.find_by_nr(code)
    self.find_by_code(code)
  end
end
