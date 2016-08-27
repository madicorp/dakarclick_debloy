class UserMailer < ApplicationMailer

  def payment_process user ,invoice
    @user = user
    @invoice = invoice
    mail(subject: "New Payment Dakarclic: #{@user.email}")
  end
  def payment_success user ,invoice
    @user = user
    @invoice = invoice
    mail(subject: "New Payment Dakarclic: #{@user.email}")
  end
  def payment_failed user ,invoice
    @user = user
    @invoice = invoice
    mail(subject: "New Payment Dakarclic: #{@user.email}")
  end
end
