class CreateSellLocationsSuggestions < ActiveRecord::Migration
  def change
    create_table :sell_locations_suggestions do |t|
      t.string :user_name
      t.string :user_email
      t.string :address
      t.string :name
      t.string :info
      t.float :lat
      t.float :lng
      t.boolean :visibility, default: true, null: false
      t.integer :sell_location_id
      t.datetime :created_at
      t.boolean :reviewed, default: false, null: false
    end
  end
end
