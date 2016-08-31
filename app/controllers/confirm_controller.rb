require 'open-uri'
require 'paypal-sdk-rest'
class ConfirmController < ApplicationController
    def index
        redirect_to root_path
    end
    def paydunya
        if params[:token].present?
            token = params[:token]
            invoice = Paydunya::Checkout::Invoice.new
            if invoice.confirm(token)
                order = Order.find_by_id invoice.get_custom_data('orderid').to_i
                user = User.find_by_id order.user_id
                case invoice.status
                    when  'completed'
                        unless order.status == invoice.status
                            unit = invoice.get_custom_data("units")
                            if user.units.nil?
                                user.units = 0
                            end
                            user.units += unit.to_i
                            user.save
                            flash[:notice] = "Payment Completed"
                            UserMailer.payment_success(user, invoice).deliver_now
                        else
                            flash[:alert] = "Payment already Completed"
                        end
                    when 'pending'
                        UserMailer.payment_process(user, invoice).deliver_now
                        flash[:info] = "Payment Pending"
                    when 'cancelled'
                        UserMailer.payment_failed(user, invoice).deliver_now
                        flash[:alert] = "Payment Cancelled"
                    when 'success'
                        UserMailer.payment_failed(user, invoice).deliver_now
                        flash[:alert] = "Payment Cancelled"
                end
                order.status = invoice.status
                order.receipt_url = invoice.receipt_url
                order.save
            end
            unless current_user.nil?
                redirect_to edit_user_registration_path
            else
                redirect_to root_path
            end
        else
            redirect_to root_path
        end
    end
end