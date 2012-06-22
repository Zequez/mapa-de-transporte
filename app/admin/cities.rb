ActiveAdmin.register City do
  controller do
    cache_sweeper :city_sweeper
    defaults finder: :from_param
  end

  member_action :edit_sell_locations do
    @city = City.from_param(params[:id])
  end

  action_item :only => :show do
    link_to(SellLocation.model_name.human, edit_sell_locations_admin_city_path(city))
  end

  form partial: "edit_form"

  index do
    column :id
    column :name
    column :perm
    column :viewport do |city|
      city.viewport.blank? ? t('no') : t("yes")
    end
    
    default_actions

    column do |city|
      link_to SellLocation.model_name.human, edit_sell_locations_admin_city_path(city)
    end
  end
end
