class SellLocationsSuggestionsController < InheritedResources::Base
  layout false

  actions :new, :create

  def create
    create! do |success, failure|
      success.html { render "thank_you" }
    end
  end
end