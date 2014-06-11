class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  include Extensions::UUID

  before_save :ensure_authentication_token!

  belongs_to :location
  has_and_belongs_to_many :roles

  validates_uniqueness_of :user_no

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :authentication_keys => [:user_no]

  def ensure_authentication_token!
    if authentication_token.blank?
      self.authentication_token = generate_authentication_token
    end
  end

  def role?(role)
    return !! self.roles.find_by_name(role.to_s.camelize)
  end

  def email_required?
    false
  end

  private
  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless User.where(authentication_token: token).first
    end
  end
end
