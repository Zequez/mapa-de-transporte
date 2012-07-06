class SellLocationsSuggestionsController < ApplicationController
  layout false

  def create
    @sell_locations_suggestion = SellLocationsSuggestion.new params[:sell_locations_suggestion], as: :user
    @sell_locations_suggestion.user_address = request.ip

    if @sell_locations_suggestion.save
      render 'thank_you'
    else
      render 'new'
    end
  end
end