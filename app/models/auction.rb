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
  def self.top_auction
    self.active(nil, "created_at desc").where("is_top = ?", true).first
  end
  def self.active limitation = nil, order =''
    Auction.all.where("auctions.auction_close > ? and auctions.status = ? ", Time.now,true).limit(limitation).order(order)
  end
  def self.coming limitation = nil, order =''
    Auction.all.where("auctions.auction_close > ? and auctions.status = ? ", Time.now,false).limit(limitation).order(order)
  end
  def self.closed limitation = nil, order =''
    Auction.all.where("auctions.auction_close < ?  and auctions.status = ? ", Time.now,true).limit(limitation).order(order)
  end
  def topbid_user
      if top_bid.nil?
          '...'
      else
          user = User.find_by_id top_bid.user_id
          user.id if !user.nil?
      end
  end

  def podium
    names = Array.new(3)
    podium = bids.joins(:user).group("bids.id, users.id").order("value DESC")

    unless podium.nil?
      first = podium.first
      names[0] = first.user.username unless first.nil?
    end
    unless first.nil?
      secound = podium.where("user_id <> ? ", first.user_id).first
      names[1] = secound.user.username unless secound.nil?
    end
    unless secound.nil?
      third = podium.where("user_id <> ? and user_id <> ? ", first.user_id, secound.user_id).first
      names[2] = third.user.username unless third.nil?
    end

    return names
  end
  def self.total_value_online
    Auction.active.sum(:value)
  end
  def active_robots
    Robot.joins(:auction).where(:is_active => true, :auction_id => self.id)
  end
end
