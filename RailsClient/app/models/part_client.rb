class PartClient < ActiveRecord::Base
  validates :client_part_nr,presence:{message:'客户零件号不可为空'}
	belongs_to :part
  belongs_to :client,class_name:'Tenant',foreign_key: :client_tenant_id
end
