class AdminMailer < ApplicationMailer
  default to: 'contact@dakarclic.com',
          from: 'contact@dakarclic.com'

  def new_registration(user)
    @user = user
    mail(subject: "New User Signup: #{@user.email}")
  end
end
