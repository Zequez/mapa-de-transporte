class BusSweeper < ActionController::Caching::Sweeper
  observe Bus

  def after_save(bus)
    if bus.name_changed?
      expire_action controller: "/buses_images_generator", action: "show"
    end
  end
end