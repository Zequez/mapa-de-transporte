class CreateSellLocations < ActiveRecord::Migration
  def change
    create_table :sell_locations do |t|
      t.float :lat
      t.float :lng
      t.string :name
      t.string :address
      t.string :info
      t.datetime :created_at
      t.boolean :card_selling
      t.boolean :card_reloading
      t.boolean :ticket_selling
    end
  end
end
