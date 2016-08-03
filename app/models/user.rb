class User < ActiveRecord::Base
  has_many :commandes
  has_many :robots
  has_many :comments, dependent: :delete_all
  has_many :submissions
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,:timeoutable, :validatable ,:timeout_in => 10.minutes
end
