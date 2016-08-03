class Auction < ActiveRecord::Base
  belongs_to :product
  has_many :bids
  has_many :robots
  belongs_to :user

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
      if top_bid.nil?
          '...'
      else
          user = User.find_by_id top_bid.user_id
          user.id if !user.nil?
      end
  end

  def active_robots
    Robot.joins(:auction).where(:is_active => true, :auction_id => self.id)
  end
end
