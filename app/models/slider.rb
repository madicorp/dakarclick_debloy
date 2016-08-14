class Slider < ActiveRecord::Base
  has_attached_file :image
  validates_attachment_content_type :image, :content_type => [/\Aimage/, 'application/octet-stream']
  has_attached_file :content
  validates_attachment_content_type :content, :content_type => [/\Aimage/, 'application/octet-stream']
end
