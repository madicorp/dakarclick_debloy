class Auction < ActiveRecord::Base
  belongs_to :product
  has_many :bids

  def top_bid
      bids.order(value: :desc).first
  end

  def current_bid
     top_bid.nil? ? value :  top_bid.value
  end

  def ended?
      auction_close < Time.now
  end

  def topbid_user
      if(top_bid.nil?)
          '...'
      else
          user = User.find_by_id top_bid.user_id
          user.name
      end
  end
end
