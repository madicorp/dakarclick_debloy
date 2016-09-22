class User < ActiveRecord::Base
  has_many :orders, dependent: :destroy
  has_many :robots, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :submissions, dependent: :destroy
  validates_presence_of :username
  validates_uniqueness_of :username
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable ,
         :recoverable, :rememberable, :trackable,:timeoutable, :validatable ,:timeout_in => 10.minutes

  after_create :send_admin_mail
  def send_admin_mail
    AdminMailer.registration(self).deliver_now
  end
end
