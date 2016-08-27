class UpdateConfirmableToDevise < ActiveRecord::Migration
  def change
    add_column :users, :unconfirmed_email, :stirng
  end
end
