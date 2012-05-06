ActiveAdmin.register Bus do
  #before_filter { @skip_sidebar = true }

  scope :for_admin_index, default: true

  filter :city
  filter :bus_group
  filter :name

  controller do
    cache_sweeper :bus_sweeper
    cache_sweeper :city_sweeper

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
    column :name do |bus|
      if not bus.visible
        raw "<span style='color: red; font-weight: bold;' title='No visible'>#{bus.name}</span>"
      else
        bus.name
      end
    end
    column :bus_group
    column :city
    column :card
    column :cash
    column :delay
    column :start_time
    column :end_time
    column :alert_message
    column :background_color do |bus|
      color_column(bus.background_color)
    end
    column :text_color do |bus|
      color_column bus.text_color
    end
    default_actions
  end

  form partial: "edit_form"
end
