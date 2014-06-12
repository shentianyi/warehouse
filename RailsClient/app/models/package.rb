class Package < ActiveRecord::Base
  include Extensions::UUID

  belongs_to :fortlift
  has_one :package_position
  has_one :position, :through => :package_position
  has_many :state_logs, as: :stateable

  # when a package is added to the fortlift
  # please do this
  #here is code for Leoni
  after_save :auto_shelved

  # set_position
  def set_position
    if self.fortlift.nil?
      return
    end

    if pp = PartPosition.where("partnum = ? ADN whouse_name = ? ",self.partnum,self.fortlift.whouse).first
      if self.package_position.nil?
        self.create_package_position(position_id: pp.position_id)
      else
        self.package_position.position_id = pp.position_id
      end
      self.package_position.save
    end
  end

  # remove_position
  def remove_position
    if self.package_position
      self.package_position.destroy
    end
  end

  private
  def auto_shelved
    #if partnum changed, reset package position
    if self.partnum_changed?
      set_position
    end
  end
end
