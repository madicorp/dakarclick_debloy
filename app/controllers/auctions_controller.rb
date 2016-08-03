class AuctionsController < ApplicationController

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

    def closed
        @auctionClosed  = Auction.paginate(page: params[:page]).order('created_at DESC').where("auctions.auction_close < ?", Time.now)
    end

    def online
        @auctionOnline  = Auction.paginate(page: params[:page]).order('created_at DESC').where("auctions.auction_close > ?", Time.now)
    end

    private
    def auction_params
        params.require(:auction).permit(:value , :auction_close)
    end
end
