class AddUserAddressToSellLocationsSuggestion < ActiveRecord::Migration
  def change
    add_column :sell_locations_suggestions, :user_address, :string

  end
end
