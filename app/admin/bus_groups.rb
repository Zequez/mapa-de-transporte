ActiveAdmin.register BusGroup do
  controller do
    cache_sweeper :city_sweeper
  end

  before_filter { @skip_sidebar = true }

  index do
    column :name
    column :city
    default_actions
  end
end
