class FortliftItem < ActiveRecord::Base
  include Extensions::UUID
  include Extensions::STATE

  belongs_to :package
  belongs_to :fortlift
end
