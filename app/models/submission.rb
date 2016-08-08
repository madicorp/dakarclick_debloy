class Submission < ActiveRecord::Base
    belongs_to :user
    has_attached_file :image,
                      :path =>   ":rails_root/upload/:rails_env/:class/:attachment/:id_partition/:style/:filename",
                      :url => "/upload/:rails_env/:class/:attachment/:id_partition/:style/:filename"
    validates_attachment_content_type :image, :content_type => [/\Aimage/, 'application/octet-stream']
end
