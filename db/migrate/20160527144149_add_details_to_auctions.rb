class AddDetailsToAuctions < ActiveRecord::Migration
  def change
    add_column :auctions, :name, :string
    add_column :auctions, :description, :text
    add_column :auctions, :status, :string
  end
end
