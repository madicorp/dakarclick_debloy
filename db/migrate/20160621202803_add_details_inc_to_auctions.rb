class AddDetailsIncToAuctions < ActiveRecord::Migration
  def change
    add_column :auctions, :valuetoinc, :int
    add_column :auctions, :timetoinc, :int
  end
end
