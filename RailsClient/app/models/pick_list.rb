class PickList < ActiveRecord::Base
  include Extensions::UUID
  belongs_to :user

  def generate_id
    "P#{Time.now.to_milli}"
  end
end
