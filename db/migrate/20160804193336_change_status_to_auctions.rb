class ChangeStatusToAuctions < ActiveRecord::Migration
  def change
      remove_column :auctions , :status , :string
      add_column :auctions , :status , :boolean
  end
end
