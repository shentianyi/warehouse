class Regex < ActiveRecord::Base
  self.inheritance_column = nil
  include Extensions::UUID
  belongs_to :localtion
end
