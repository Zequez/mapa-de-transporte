ActiveAdmin.register City do
  controller do
    cache_sweeper :city_sweeper
    defaults finder: :from_param
  end

  form partial: "edit_form"

  index do
    column :id
    column :name
    column :perm
    column :viewport
    
    default_actions
  end
end
