class CreateRobots < ActiveRecord::Migration
  def change
    create_table :robots do |t|
      t.references :user, index: true, foreign_key: true
      t.references :auction, index: true, foreign_key: true
      t.timestamp :ends_at
      t.integer :units
      t.boolean :is_active

      t.timestamps null: false
    end
  end
end
