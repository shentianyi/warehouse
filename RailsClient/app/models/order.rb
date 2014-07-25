class Order < ActiveRecord::Base
  include Extensions::UUID

  belongs_to :user

  has_many :order_items, :dependent => :destroy

  def generate_id
    "OD#{Time.now.to_milli}"
  end
end
