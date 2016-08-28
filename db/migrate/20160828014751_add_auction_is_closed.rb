class AddAuctionIsClosed < ActiveRecord::Migration
  def change
    add_column :auctions, :is_closed, :boolean
  end
end
