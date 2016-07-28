class AddAuctionCloseToAuctions < ActiveRecord::Migration
  def change
    add_column :auctions, :auction_close, :timestamp
  end
end
