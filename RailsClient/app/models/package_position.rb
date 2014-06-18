class PackagePosition < ActiveRecord::Base
  include Extensions::UUID

  
  belongs_to :package, :dependent => :destroy
  belongs_to :position, :dependent => :destroy

  FK=%w(position_id package_id)

  before_update :set_update_flag
  private
  def set_update_flag
    if self.package_id_changed? || self.position_id_changed?
      new_package_id=self.package_id
      new_position_id=self.position_id
      PackagePosition.create(package_id: new_package_id, position_id: new_position_id)
      self.package_id=self.package_id_was
      self.position_id =self.position_id_was
      self.delete=true
    end
  end
end
