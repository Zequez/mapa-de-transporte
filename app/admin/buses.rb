ActiveAdmin.register Bus do
  #before_filter { @skip_sidebar = true }

  scope :for_admin_index, default: true

  filter :city
  filter :bus_group
  filter :name

  controller do
    def new
      @bus = Bus.for_new
      new!
    end

    def edit
      resource.build_routes
      edit!
    end
  end

  index do
    column :name
    column :bus_group
    column :city
    column :card
    column :cash
    column :delay
    column :start_time
    column :end_time
    column :color_1 do |bus|
      color_column(bus.color_1)
    end
    column :color_2 do |bus|
      color_column bus.color_2
    end
    default_actions
  end

  form partial: "edit_form"
end
