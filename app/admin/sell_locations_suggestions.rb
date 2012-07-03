ActiveAdmin.register SellLocationsSuggestion do
  index do
    column :id
    column :sell_location_id
    column :address
    column :name
    column :info
    column :card_selling
    column :card_reloading
    column :ticket_selling
    column :visibility
    column :user_name
    column :user_email
    column :user_address

    default_actions
  end
end
