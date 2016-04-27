class BackPartItem < ActiveRecord::Base
  include Extensions::UUID

  belongs_to :back_part
  belongs_to :part
  belongs_to :whouse
  belongs_to :position

  def generate_id
    "BPI#{Time.now.to_milli}"
  end
end
