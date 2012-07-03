class AddCommentToSellLocationsSuggestions < ActiveRecord::Migration
  def change
    add_column :sell_locations_suggestions, :comment, :string

  end
end
