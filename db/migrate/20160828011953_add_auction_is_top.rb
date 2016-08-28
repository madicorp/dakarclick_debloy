class AddAuctionIsTop < ActiveRecord::Migration
  def change
    add_column :auctions, :is_top, :boolean
  end
end
