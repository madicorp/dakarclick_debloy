class AuctionsController < ApplicationController
  skip_before_action :verify_authenticity_token, :only => [:ended]
  def index
    params[:filter].present? ? filter = params[:filter] : filter = ""
    case filter
      when "online"
        @status = "en cours"
        @auctions =  Auction.active.paginate(page: params[:page])
      when "closed"
        @status = "Terminés"
        @auctions =  Auction.closed.paginate(page: params[:page])
      when "coming"
        @status = "A Venir"
        @auctions =  Auction.coming.paginate(page: params[:page])
      else
        redirect_to root_path
    end
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

  def ended
    auction_id = params[:auction_id]
    auction = Auction.find auction_id
    @winner = Struct.new(:auction, :winner).new(auction.name,auction.top_bid.user.username)
  end
  private
  def auction_params
    params.require(:auction).permit(:value , :auction_close)
  end
end
