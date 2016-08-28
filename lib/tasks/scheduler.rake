task :update_auction => :environment do
  Auction.all.where("auctions.auction_close < ?  and auctions.status = ?  and auctions.id_closed = ?", Time.now,true, false).each do |auction|
    auction.is_closed = true
    auction.save
    AdminMailer.auction_ended(auction).deliver
    UserMailer.auction_winner(auction).deliver
  end
end