ActiveAdmin.register Domain do
  index do
    column :id
    column :name
    column :city
    column :google_analytics_id
    default_actions
  end

  form do |f|
    f.inputs :name, :city, :google_analytics_id
    f.buttons
  end
end
