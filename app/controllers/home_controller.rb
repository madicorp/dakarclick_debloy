class HomeController < ApplicationController

    def index
        @auctionOnline = Auction.joins(:product).where("auctions.auction_close > ?", Time.now).limit(4).order('created_at DESC')
        @auctionClosed  = Auction.joins(:product).where("auctions.auction_close < ?", Time.now).limit(4).order('created_at DESC')
    end
end
