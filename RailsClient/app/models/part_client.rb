class PartClient < ActiveRecord::Base
  validates :client_part_nr, presence: {message: '客户零件号不可为空'}
  belongs_to :part
  belongs_to :client, class_name: 'Tenant', foreign_key: :client_tenant_id

  before_validation :check_uniq


  def check_uniq
    if pc=PartClient.where(client_part_nr: self.client_part_nr, client_tenant_id: self.client_tenant_id).first
      errors.add(:client_part_nr, "该客户零件#{self.client_part_nr}已有对应关系：#{pc.part.nr}")
    end
  end
end
