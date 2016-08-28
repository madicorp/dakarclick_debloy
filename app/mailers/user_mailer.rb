class UserMailer < ApplicationMailer

  def payment_process user ,invoice
    @user = user
    @invoice = invoice
    mail(to: @user.email, subject: "New Payment Dakarclic: #{@user.email}")
  end
  def payment_success user ,invoice
    @user = user
    @invoice = invoice
    mail(to: @user.email, subject: "New Payment Dakarclic: #{@user.email}")
  end
  def payment_failed user ,invoice
    @user = user
    @invoice = invoice
    mail(to: @user.email, subject: "New Payment Dakarclic: #{@user.email}")
  end
  def auction_winner auction
    @auction = auction
    mail(to: @auction.top_bid.user.email, subject: "Dakarclic - You Won !")
  end
end
