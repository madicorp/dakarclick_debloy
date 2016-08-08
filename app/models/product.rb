class Product < ActiveRecord::Base
    has_many :auction
    has_attached_file :image
    validates_attachment_content_type :image, :content_type => [/\Aimage/, 'application/octet-stream']
    def has_auction?
        auction.present?
    end

end
