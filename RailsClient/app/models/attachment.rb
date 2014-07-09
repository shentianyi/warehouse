class Attachment < ActiveRecord::Base
  include Extensions::UUID
  self.inheritance_column = nil
end
