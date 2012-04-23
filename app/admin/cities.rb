ActiveAdmin.register City do
  controller do
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
