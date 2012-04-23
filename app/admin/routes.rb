ActiveAdmin.register Route do
  index do
    column :bus
    column :name
    column :addresses
    column :encoded
    default_actions
  end
end
