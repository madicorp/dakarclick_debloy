class AddAttachmentToSliders < ActiveRecord::Migration
  def self.up
    change_table :sliders do |t|
      t.attachment :image
      t.attachment :content
    end
  end

  def self.down
    remove_attachment :sliders, :image
    remove_attachment :sliders, :content
  end
end
