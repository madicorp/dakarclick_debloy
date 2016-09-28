class AdminMailer < ApplicationMailer
  default to: 'contact@dakarclic.com',
          from: 'Dakarclic <contact@dakarclic.com>'

  def registration(user)
    @user = user
    mail(subject: "New User Signup: #{@user.email}")
  end
  def auction_ended auction
    @auction = auction
    mail(subject: "Auction Ended:")
  end
end
