class Bid < ActiveRecord::Base
  belongs_to :user
  belongs_to :auction

  validates_numericality_of :value
  def self.count_bid_by_date begins_at, ends_at
    Bid.all.where(:created_at => begins_at..ends_at).group_by_day(:created_at).count
  end
end