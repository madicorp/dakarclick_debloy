require 'paypal-sdk-rest'
require 'money'
require 'money/bank/google_currency'
require 'monetize'
require 'restclient'
class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]

  # # GET /orders
  # # GET /orders.json
  # def index
  #   @orders = Order.all
  # end
  #
  # # GET /orders/1
  # # GET /orders/1.json
  # def show
  # end

  # GET /orders/new
  def new

    @order = Order.new
    @order.quantity = params[:qte] unless params[:qte].nil?
    @order.total_ttc = params[:total] unless params[:total].nil?
    @order.total_ht = @order.total_ttc - params[:tva].to_s.to_d unless params[:total].nil? && params[:tva].nil?
  end

  # GET /orders/1/edit
  # def edit
  # end

  def create
    p order_params
    @order = Order.new order_params
    @order.status= "Pending"
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
        when "card"
          Money.default_bank = Money::Bank::GoogleCurrency.new
          card = card_params

          $api_key = 'Z4111GCL07LLE54A43IB21tYeBK0oroLCcW93KKUCMZeffo9I'
          $shared_secret = 'FYj4#{CWkNdX+3XFOrRYvpsXKa1WdDXj5pSa41jP'
          $base_uri = "cybersource/"
          $resource_path = "payments/v1/authorizations"
          $query_string = "apiKey=" + $api_key

          # ###Payment
          # A Payment Resource; create one using
          # the above types and intent as `sale or `authorize`

          request_body = {
              "amount" =>  '%.2f' % (118.to_money(:XOF).exchange_to(:USD)* @order.quantity),
              "currency" => "USD",
              "payment" => {
                  "cardNumber" => card[:number].tr(" ", ""),
                  "cardExpirationMonth" => card[:month],
                  "cardExpirationYear" => card[:year],
                  "cvn" => card[:cvc]
              },
              "merchantDefinedData"=> {
              },
              "items"=> [{
                             "productSKU"=> "Unités DakarClick",
                             "quantity"=> @order.quantity,
                             "amount"=> '%.2f' % 118.to_money(:XOF).exchange_to(:USD),
                         }]
          }.to_json;
          response = authorize_credit_card(request_body)
          p response
=begin
          @payment = PayPal::SDK::REST::Payment.new({
                                     :intent => "sale",

                                     # ###Payer
                                     # A resource representing a Payer that funds a payment
                                     # Use the List of `FundingInstrument` and the Payment Method
                                     # as 'credit_card'
                                     :payer => {
                                         :payment_method => "credit_card",
                                         :funding_instruments => [{
                                                                      :credit_card => {
                                                                          :type => card[:type],
                                                                          :number => card[:number].tr(" ", ""),
                                                                          :expire_month => card[:month],
                                                                          :expire_year => card[:year],
                                                                          :cvv2 => card[:cvc],
                                                                          :first_name => card[:firstname],
                                                                          :last_name => card[:lastname],
                                                                      }
                                                                  }]
                                     },
                                     :transactions =>  [{
                                                            # Item List
                                                            :item_list => {
                                                                :items => [{
                                                                               :name => "Unités DakarClick",
                                                                               :currency => "EUR",
                                                                               :price => '%.2f' % 118.to_money(:XOF).exchange_to(:EUR),
                                                                               :quantity => @order.quantity}]},
                                                            :amount =>  {
                                                                :total =>  '%.2f' % (118.to_money(:XOF).exchange_to(:EUR)* @order.quantity),
                                                                :currency =>  "EUR"
                                                            },
                                                            :description =>  "This is the payment transaction description."
                                                        }]
                                 })
          # Create Payment and return status( true or false )
          if @payment.create
            p "Payment[#{@payment.id}] created successfully"
              unit = @payment.transactions[0].item_list.items[0].quantity
            user = current_user
            if user.units.nil?
                user.units =0
            end

            user.units  += unit.to_i
           if user.save
               redirect_to confirm_path
           end

          else
            # Display Error message
            p "Error while creating payment:"
            p @payment.error.inspect
          end
=end
          #redirect_to root_path
        when "paypal"
          Money.default_bank = Money::Bank::GoogleCurrency.new
          @payment = PayPal::SDK::REST::Payment.new({
                                     :intent =>  "sale",
                                     :payer =>  {
                                         :payment_method =>  "paypal"
                                     },
                                     :redirect_urls => {
                                         :return_url => "http://localhost:3000/confirm/paypal",
                                         :cancel_url => "http://localhost:3000/confirm/paypal"
                                     },
                                     :transactions =>  [{ # Item List
                                                          :item_list => {
                                                              :items => [{
                                                                             :name => "Unités DakarClick",
                                                                             :currency => "EUR",
                                                                             :price => '%.2f' % 118.to_money(:XOF).exchange_to(:EUR),
                                                                             :quantity => @order.quantity}]},
                                                           :amount =>  {
                                                                :total =>  '%.2f' % (118.to_money(:XOF).exchange_to(:EUR)* @order.quantity),
                                                                :currency =>  "EUR"
                                                            },
                                                            :description =>  "This is the payment transaction description."
                                      }]
                                 })

          # Create Payment and return status
          if @payment.create
            # Redirect the user to given approval url
            @redirect_url = @payment.links.find{|v| v.method == "REDIRECT" }.href
            redirect_to @redirect_url.to_s.split(": ").last.tr("\"","")
            p "Payment[#{@payment.id}]"
            p "Redirect: #{@redirect_url}"
          else
            p @payment.error.inspect
          end
        else
          redirect_to root_path
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
private
  def get_xpay_token(resource_path, query_string, request_body)
    require 'digest'
    timestamp = Time.now.getutc.to_i.to_s
    hash_input = timestamp + resource_path + query_string + request_body
    hash_output = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), $shared_secret, hash_input)
    return "xv2:" + timestamp + ":" + hash_output
  end

  def authorize_credit_card(request_body)
    xpay_token = get_xpay_token($resource_path, $query_string, request_body)
    full_request_url = "https://sandbox.api.visa.com/" + $base_uri + $resource_path + "?" + $query_string

    p
      'url' => full_request_url,
      'method' => :post,
          'payload' => request_body,
      'headers' => {
          "content-type" => "application/json",
          "x-pay-token" => xpay_token
      }
    )

    begin
      response = RestClient::Request.execute(:url => full_request_url,
                                             :method => :post,
                                             :payload => request_body,
                                             :headers => {
                                                 "content-type" => "application/json",
                                                 "x-pay-token" => xpay_token
                                             }
      )
    rescue RestClient::ExceptionWithResponse => e
      response = e.response
    end
    return response
  end
end

