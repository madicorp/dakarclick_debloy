class HomeController < ApplicationController

    def index
        @auctions = Auction.all
    end
end
