class Regex < ActiveRecord::Base
  self.inheritance_column = nil
  include Extensions::UUID
  belongs_to :regexable, polymorphic: true

  before_save :count_fix_length

  def count_fix_length
    self.prefix_length=self.prefix_string.length unless self.prefix_string.nil?
    self.suffix_length=self.suffix_string.length unless self.suffix_string.nil?
  end
end