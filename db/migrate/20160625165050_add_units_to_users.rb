class AddUnitsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :units, :integer
  end
end
