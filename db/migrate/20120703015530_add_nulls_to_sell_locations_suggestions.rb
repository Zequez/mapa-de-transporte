class AddNullsToSellLocationsSuggestions < ActiveRecord::Migration
  def change
    change_column :sell_locations_suggestions, :lat,            :float,   default: nil, null: true
    change_column :sell_locations_suggestions, :lng,            :float,   default: nil, null: true
    change_column :sell_locations_suggestions, :visibility,     :boolean, default: nil, null: true
    change_column :sell_locations_suggestions, :card_selling,   :boolean, default: nil, null: true
    change_column :sell_locations_suggestions, :card_reloading, :boolean, default: nil, null: true
    change_column :sell_locations_suggestions, :ticket_selling, :boolean, default: nil, null: true
  end
end
