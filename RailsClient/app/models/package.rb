class Package < ActiveRecord::Base
  include Extensions::UUID

  belongs_to :fortlift
  has_one :package_position
  has_one :position, :through => :package_position
  has_many :state_logs, as: :stateable

  #here is code for Leoni
  after_save :auto_shelved

  private
  def auto_shelved
    #if partnum changed, reset package position
    if self.partnum_changed? || self.fortlift_changed?
      if pp = PartPosition.where("partnum = ? ADN whouse_name = ? ",self.partnum,self.fortlift.whouse).first
        if self.package_position.nil?
          self.package_position = PackagePosition.new
          self.package_position.position = pp.position
        else
          self.package_position.position_id = pp.position_id
        end
        self.package_position.save
      end
    end
  end
end
