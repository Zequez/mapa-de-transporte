ActiveAdmin.register BusGroup do
  before_filter { @skip_sidebar = true }

  index do
    column :name
    column :city
    default_actions
  end
end
