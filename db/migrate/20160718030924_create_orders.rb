class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :reference
      t.text :designation
      t.decimal :unit_price_ht
      t.integer :quantity
      t.decimal :total_ht
      t.decimal :total_ttc
      t.string :status
      t.string :payment_method
      t.timestamps null: false
      t.references :user, index: true, foreign_key: true
    end
  end
end
