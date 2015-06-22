class ScrapList < ActiveRecord::Base
  has_many :scrap_list_items, :dependent => :destroy
end
