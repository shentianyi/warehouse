class Order < ActiveRecord::Base
  include Extensions::UUID

  belongs_to :user

  has_many :order_items, :dependent => :destroy
  belongs_to :source, class_name: "Location"

  def generate_id
    "OD#{Time.now.to_milli}"
  end
end
