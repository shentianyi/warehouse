class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  include Extensions::UUID

  belongs_to :location

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
