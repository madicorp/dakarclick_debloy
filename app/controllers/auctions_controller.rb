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
    end

    private
    def auction_params
        params.require(:auction).permit(:value , :auction_close)
    end
end
