class PackageType < ActiveRecord::Base
  validates :name, presence:{message:'名称不可为空'}
  validates :nr, presence:{message:'编号不可为空'}
  has_many :parts
end
