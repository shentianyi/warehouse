class RegexCategory < ActiveRecord::Base
  self.inheritance_column = nil
  include Extensions::UUID
  has_many :regexes,dependent: :destroy
end
