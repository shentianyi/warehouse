class Wrappage < ActiveRecord::Base
  validates_presence_of :nr, :message => "nr不能为空!"
  validates_uniqueness_of :nr, :message => "nr不能重复!"

  has_many :part_wrappages, :dependent => :destroy
  has_many :parts, :through => :part_wrappages
  belongs_to :mirror, class_name: 'Part'


  after_create :create_mirror

  def create_mirror
    if (pt=PartType.find_by_nr('Container')) && Part.find_by_nr(self.nr).blank?
      part=Part.create(nr: self.nr, part_type_id: pt.id)
      self.mirror=part
      self.save

      Location.all.each do |l|
        if l.default_whouse
          pp=PartPosition.new(part_id: part.id, position_id: l.default_whouse.default_position.id)
          pp.save
        end
      end
    else
      errors.add(:mirror, "容器已存在")
    end
  end
end