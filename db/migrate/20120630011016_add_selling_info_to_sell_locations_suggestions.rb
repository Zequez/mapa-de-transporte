class AddSellingInfoToSellLocationsSuggestions < ActiveRecord::Migration
  def change
    add_column :sell_locations_suggestions, :card_selling, :boolean, default: false, null: false

    add_column :sell_locations_suggestions, :card_reloading, :boolean, default: false, null: false

    add_column :sell_locations_suggestions, :ticket_selling, :boolean, default: false, null: false

  end
end
