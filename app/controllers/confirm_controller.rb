require 'open-uri'
require 'paypal-sdk-rest'
class ConfirmController < ApplicationController
    skip_before_action :verify_authenticity_token, :only => [:paydunya]
    def index
        redirect_to root_path
    end
    def paydunya
        if params[:token].present? || params[:data][:invoice][:token].present?
            token = params[:token].present? ? params[:token] : params[:data][:invoice][:token]
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
                            flash[:notice] = "Paiement Validé"
                            UserMailer.payment_success(user, invoice).deliver_now
                        else
                            flash[:alert] = "Paiement déja validé"
                        end
                    when 'pending'
                        UserMailer.payment_process(user, invoice).deliver_now
                        flash[:info] = "Paiement en attente"
                    when 'cancelled'
                        UserMailer.payment_failed(user, invoice).deliver_now
                        flash[:alert] = "Paiement annulé"
                    when 'success'
                        UserMailer.payment_failed(user, invoice).deliver_now
                        flash[:alert] = "Paiement annulé"
                end
                order.status = invoice.status
                order.receipt_url = invoice.receipt_url
                user.save if  order.save

            end
            unless current_user.nil?
                p "no invoice confirm"
                redirect_to edit_user_registration_path
            else
                redirect_to root_path
            end
        else
            redirect_to root_path
        end
    end
end