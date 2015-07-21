class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  include Extensions::UUID
  include Import::UserCsv

  belongs_to :location
  has_many :deliveries
  has_many :pick_lists
  has_many :pick_item_filters
  has_many :inventory_lists
  #has_many :inventory_list_items
  
  before_save :ensure_authentication_token!

  validates_uniqueness_of :id,:user_name

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :authentication_keys => [:user_name]

  def ensure_authentication_token!
    if authentication_token.blank?
      self.authentication_token = generate_authentication_token
    end
  end

  def method_missing(method_name, *args, &block)
    if Role::RoleMethods.include?(method_name)
      Role.send(method_name, self.role_id)
    else
      super
    end
  end

  def role
    Role.display(self.role_id)
  end

  def email_required?
    false
  end

  def employee?
    if self.admin? || self.manager?
      false
    else
      true
    end
  end

  def self.role_user role_id
    User.where(role_id:role_id).all
  end


  def location_destinations
    self.location.destinations
  end

  def location_destination_ids
    self.location_destinations.pluck(:id)
  end

  private
  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless User.where(authentication_token: token).first
    end
  end
end
