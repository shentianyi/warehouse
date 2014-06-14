class Package < ActiveRecord::Base
  include Extensions::UUID
  include Extensions::STATE

  has_one :forklift_item, :dependent => :destroy
  has_one :package_position
  has_one :position, :through => :package_position
  has_many :state_logs, as: :stateable

  belongs_to :user
  belongs_to :location
  belongs_to :part

  # when a package is added to the forklift
  # please do this
  #here is code for Leoni
  after_save :auto_shelved

  #-------------
  # Instance Methods
  #-------------

  # add_to_forklift
  def add_to_forklift forklift_id
    if self.forklift_item.nil?
      self.create_forklift_item(forklift_id: forklift_id)
    else
      self.forklift_item.forklift_id = forklift_id
      self.forklift_item.is_delete = false
      self.forklift_item.save
    end
    set_position
  end

  # remove_form_forklift
  def remove_from_forklift
    if self.forklift_item
      self.forklift_item.destroy
      remove_position
    end
    true
  end

  # set_position
  def set_position
    if self.forklift_item.nil?
      return
    end

    if pp = PartPosition.where("part_id = ? ADN whouse_name = ? ",self.part_id,self.forklift_item.forklift.whouse).first
      if self.package_position.nil?
        self.create_package_position(position_id: pp.position_id)
      else
        self.package_position.position_id = pp.position_id
        self.package_position.is_delete = false
      end
      self.package_position.save
    end
  end

  # remove_position
  def remove_position
    if self.package_position
      self.package_position.destroy
    end
  end

  private
  def auto_shelved
    #if partnum changed, reset package position
    if self.part_id_changed?
      set_position
    end
  end
end
