class AdminMailer < ApplicationMailer
  default to: Proc.new { Admin.pluck(:email) },
          from: 'contact@dakarclic.com'

  def new_registration(user)
    @user = user
    mail(subject: "New User Signup: #{@user.email}")
  end
end
