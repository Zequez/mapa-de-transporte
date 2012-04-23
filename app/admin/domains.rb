ActiveAdmin.register Domain do
  index do
    column :id
    column :name
    column :city
    default_actions
  end
end
