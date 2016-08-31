task :update_auction => :environment do
  Auction.all.where("auctions.auction_close < ?  and auctions.status = ?  and auctions.is_closed = ?", Time.now,true, false).each do |auction|
    auction.is_closed = true
    auction.save
    AdminMailer.auction_ended(auction).deliver_now
    UserMailer.auction_winner(auction).deliver_now
  end
end