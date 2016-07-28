class PlaceBid
    attr_reader :auction, :status, :user, :value , :units, :auction_close , :nb_ench , :productid
    def initialize options
        @user_id = options[:user_id].to_i
        @auction_id = options[:auction_id].to_i
    end

    def execute
        @auction = Auction.find @auction_id
        @user = User.find @user_id

        if auction.ended? && auction.top_bid.user_id == @user_id
            @status = :won
            return false
        end

        if user.units >= 2
            auction.value += auction.valuetoinc
            auction.auction_close += auction.timetoinc.seconds
            user.units -= 2
            @value = auction.value
            @units = user.units
            @auction_close = auction.auction_close
            @productid = auction.product_id

            ActiveRecord::Base.transaction do
                auction.save
                user.save
            end
            @nb_ench = auction.bids.size + 1
        #
        # else
        #     @value = auction.value
        #     return false
        end

        bid = auction.bids.build value: @value, user_id: @user_id

        if bid.save
            return true
        else
            return false
        end
    end
end
