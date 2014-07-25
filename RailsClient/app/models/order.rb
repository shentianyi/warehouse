class Order < ActiveRecord::Base
  include Extensions::UUID

  belongs_to :user

  has_many :order_items, :dependent => :destroy
end
