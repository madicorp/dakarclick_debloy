class User < ActiveRecord::Base
  has_many :orders
  has_many :robots
  has_many :comments, dependent: :delete_all
  has_many :submissions
  validates_presence_of :username
  validates_uniqueness_of :username
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable ,
         :recoverable, :rememberable, :trackable,:timeoutable, :validatable ,:timeout_in => 10.minutes
   after_create :send_admin_mail
   def send_admin_mail
     mailer = AdminMailer.new
     mailer.new_registration(self).deliver
   end
end
