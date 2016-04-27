class BackPart < ActiveRecord::Base
  include Extensions::UUID

  has_many :back_part_items, :dependent => :destroy
  belongs_to :des_location, class_name: 'Location'
  belongs_to :src_location, class_name: 'Location'
  belongs_to :user

  def generate_id
    "BP#{Time.now.to_milli}"
  end
end
