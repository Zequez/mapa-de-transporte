ActiveAdmin.register SellLocation do
  controller do

  end

  form partial: "edit_and_review_form"

  action_item :only => :index do
    reviewable_sell_location = SellLocation.first_with_suggestion
    if reviewable_sell_location
      link_to("Review " + SellLocationsSuggestion.model_name.human, edit_admin_sell_location_path(reviewable_sell_location))
    else
      nil
    end
  end

  index do
    column :id
    column :address
    column :name
    column :info
    column :card_selling
    column :card_reloading
    column :ticket_selling
    column :visibility
    column :inexact
    column :manual_position

    default_actions
  end
end
