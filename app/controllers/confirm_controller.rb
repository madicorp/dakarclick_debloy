require 'open-uri'
require 'paypal-sdk-rest'
class ConfirmController < ApplicationController
    def index

    end
    def paydunya
        if params[:token].present?
            token = params[:token]
            invoice = Paydunya::Checkout::Invoice.new
            if invoice.confirm(token)
                order = Order.find_by_id invoice.get_custom_data 'orderid'
                order.status = invoice.status
                order.save
                p order.status
                puts invoice.status
                if invoice.status.eql? 'completed'
                    unit = invoice.get_custom_data("units")
                    user = current_user
                    if user.units.nil?
                        user.units =0
                    end
                    user.units += unit.to_i
                    user.save
                    #     url = invoice.receipt_url
                    #     data = open(url).read
                    #     send_data data, :disposition => 'application/pdf', :filename=>"Confirmation.pdf"
                end
            end
            redirect_to confirm_path
        else
          redirect_to root_path
        end
    end
  def paypal
      if params[:paymentId].present?
          paymentId = params[:paymentId]
          @payment = PayPal::SDK::REST::Payment.find paymentId
          unit = @payment.transactions[0].item_list.items[0].quantity
          user = current_user
          if user.units.nil?
              user.units =0
          end
          user.units += unit.to_i
          user.save
          redirect_to confirm_path
      else
          redirect_to root_path
      end
  end
end
