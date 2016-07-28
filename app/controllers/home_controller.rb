class HomeController < ApplicationController

    def index
            @auctionOnline= Auction.joins(:product).where("auctions.auction_close > ?", Time.now)
    end
end
