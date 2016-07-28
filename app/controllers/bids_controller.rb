require "place_bid"

class BidsController < ApplicationController
     def create
         service = PlaceBid.new bids_params
         if service.execute
             redirect_to auction_path(params[:auction_id]), notice: "Bid successfully placed."
         else
             redirect_to auction_path(params[:auction_id]), alert: "Something went wrong."

         end
     end

     private

     def bids_params
         params.require(:bid).permit(:value).merge!(
         user_id: current_user.id,
         auction_id: params[:auction_id])
     end
end
