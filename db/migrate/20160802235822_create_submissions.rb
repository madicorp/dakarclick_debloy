class CreateSubmissions < ActiveRecord::Migration
  def change
    create_table :submissions do |t|
      t.text :description
      t.text :product
      t.string :contact
      t.references :user, index: true, foreign_key: true
    end
  end
end
