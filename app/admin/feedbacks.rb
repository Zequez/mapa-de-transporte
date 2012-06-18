ActiveAdmin.register Feedback do
  index do
    selectable_column
    column :address
    column :name
    column :email
    column :message
    column :created_at
    column :read
    default_actions
  end
end
