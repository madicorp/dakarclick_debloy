class Order < ActiveRecord::Base
  belongs_to :user

  def total
    unit_price_ht * quantity
  end

  def self.cash_flow begins_at, ends_at
    updated_at = Order.arel_table[:updated_at]
    range =  Order.all.where(:status => "completed", :updated_at => begins_at..ends_at).group_by_day(:updated_at).sum(:total_ttc)
    sum =  Order.all.where(:status => "completed").where(updated_at.lt(begins_at)).sum(:total_ttc)
    return {:range => range, :sum => sum}
  end
end
