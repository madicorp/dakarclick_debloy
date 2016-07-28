require 'open-uri'

class ConfirmController < ApplicationController
    def index
        token = params[:token]
        invoice = Paydunya::Checkout::Invoice.new
        if invoice.confirm(token)
            puts invoice.status
            if invoice.status.eql? 'completed'
                unit = invoice.get_custom_data("units")
                user = current_user
                user = user.units += unit.to_i
                user.save
            #     url = invoice.receipt_url
            #     data = open(url).read
            #     send_data data, :disposition => 'application/pdf', :filename=>"Confirmation.pdf"
            end
        end
    end
end
