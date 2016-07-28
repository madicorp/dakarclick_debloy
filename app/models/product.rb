class Product < ActiveRecord::Base
    has_many :auction

    def has_auction?
        auction.present?
    end

end
