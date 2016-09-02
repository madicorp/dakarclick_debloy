require 'paypal-sdk-rest'
require 'money'
require 'money/bank/google_currency'
require 'monetize'
class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]

  # # GET /orders
  # # GET /orders.json
  def index
    redirect_to root_path
  end
  #
  # # GET /orders/1
  # # GET /orders/1.json
  # def show
  # end

  # GET /orders/new
  def new
    redirect_to root_path if current_user.nil?
    @order = Order.new
    @order.quantity = params[:qte] unless params[:qte].nil?
    @order.total_ttc = params[:total] unless params[:total].nil?
    @order.total_ht = @order.total_ttc - params[:tva].to_s.to_d unless params[:total].nil? && params[:tva].nil?
  end

  # GET /orders/1/edit
  # def edit
  # end

  def create
    redirect_to root_path if current_user.nil?
    @order = Order.new order_params
    @order.status= "pending"
    @order.user_id = current_user.id
    if @order.save
      case @order.payment_method
        when "paydunya"
          invoice = Paydunya::Checkout::Invoice.new
          invoice.add_item("Unités DakarClick", @order.quantity, @order.total_ht, @order.total_ttc)
          invoice.add_tax("TVA (18%)", @order.total_ht)
          invoice.total_amount = @order.total_ttc
          invoice.add_custom_data("units",@order.quantity)
          invoice.add_custom_data("orderid",@order.id)

          if invoice.create
            puts invoice.status
            puts invoice.response_text
            # Vous pouvez par exemple faire un "redirect_to invoice.invoice_url"
            redirect_to  invoice.invoice_url
            puts invoice.invoice_url
          else
            puts invoice.status
            puts invoice.response_text
          end
      end
    end

  end
  private
  # Use callbacks to share common setup or constraints between actions.
  def set_order
    @order = Order.find params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def order_params
    # params.fetch(:order, {})
    params.require(:order).permit(:quantity, :total_ttc ,:total_ht, :payment_method)
  end
  def card_params
    params.require(:card).permit(:number, :firstname, :lastname ,:month, :year, :cvc, :type)
  end
end