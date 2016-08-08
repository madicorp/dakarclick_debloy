class AuctionsController < ApplicationController

  def index
    params[:filter].present? ? filter = params[:filter] : filter = ""
    case filter
      when "online"
        condition = "auctions.auction_close > ? and auctions.status = ?",Time.now,true
        order = 'created_at DESC'
      when "closed"
        condition = "auctions.auction_close < ?", Time.now
        order = 'created_at DESC'
      when "coming"
        condition = "auctions.auction_close > ? and auctions.status = ?", Time.now,false
        order = 'created_at DESC'
      else
        redirect_to root_path
    end
    @auctions = Auction.paginate(page: params[:page]).order(order).where(condition)
  end

  def create
    @product = Product.find params[:product_id]
    @auction = Auction.new auction_params.merge! product_id: @product.id

    if @auction.save
      redirect_to  @product , notice: "Product was put to auction."
    else
      redirect_to  @product , alert: "Something went wrong, please review your data."
    end
  end

  # GET /auctions/1
  # GET /auctions/1.json
  def show
    @auction = Auction.find(params[:id])
    @auction = Auction.find(params[:id])
    if ! current_user.nil?
      @robot = Robot.find_by_user_id_and_auction_id  current_user.id , @auction.id
    end
    if @robot.nil?
      @robot = Robot.new
    end
  end

  private
  def auction_params
    params.require(:auction).permit(:value , :auction_close)
  end
end
