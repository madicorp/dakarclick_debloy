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
    @order.status = Paydunya::Checkout::Store.name
    @order.quantity = params[:qte] unless params[:qte].nil?
    @order.total_ttc = params[:total] unless params[:total].nil?
    @order.total_ht = @order.total_ttc - params[:tva].to_s.to_d unless params[:total].nil? && params[:tva].nil?
  end

  # GET /orders/1/edit
  # def edit
  # end

  def create
     # @order = Order.new(order_params)
    invoice = Paydunya::Checkout::Invoice.new
    @order = Order.new(order_params)
    invoice.add_item("Unités DakarClick", @order.quantity, @order.total_ht, @order.total_ttc)
    invoice.add_tax("TVA (18%)", @order.total_ht)
    invoice.total_amount = @order.total_ttc
    invoice.add_custom_data("units",@order.quantity)
    invoice.add_custom_data("orderid",@order.id)
    if invoice.create
        @order.save
        puts invoice.status
        puts invoice.response_text
        # Vous pouvez par exemple faire un "redirect_to invoice.invoice_url"
        redirect_to  invoice.invoice_url
        puts invoice.invoice_url
    else
        puts invoice.status
        puts invoice.response_text
    end

    # respond_to do |format|
    #   if @order.save
    #     format.html { redirect_to @order, notice: 'Order was successfully created.' }
    #     format.json { render :show, status: :created, location: @order }
    #   else
    #     format.html { render :new }
    #     format.json { render json: @order.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # # PATCH/PUT /orders/1
  # # PATCH/PUT /orders/1.json
  # def update
  #   respond_to do |format|
  #     if @order.update(order_params)
  #       format.html { redirect_to @order, notice: 'Order was successfully updated.' }
  #       format.json { render :show, status: :ok, location: @order }
  #     else
  #       format.html { render :edit }
  #       format.json { render json: @order.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end
  #
  # # DELETE /orders/1
  # # DELETE /orders/1.json
  # def destroy
  #   @order.destroy
  #   respond_to do |format|
  #     format.html { redirect_to orders_url, notice: 'Order was successfully destroyed.' }
  #     format.json { head :no_content }
  #   end
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      # params.fetch(:order, {})
        params.require(:order).permit(:quantity, :total_ttc ,:total_ht)
    end
end
