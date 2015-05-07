class PickList < ActiveRecord::Base
  include Extensions::UUID
  belongs_to :user
  has_many :pick_items

  def generate_id
    "P#{Time.now.to_milli}"
  end
end
