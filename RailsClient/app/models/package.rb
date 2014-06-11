class Package < ActiveRecord::Base
  include Extensions::UUID

  belongs_to :fortlift
  has_one :package_position
  has_many :state_logs, as: :stateable

  #here is code for Leoni
  after_save :set_position

  private
  def set_position
    #if partnum changed, reset package position
    if self.partnum_changed?

    end
  end
end
