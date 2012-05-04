class BusSweeper < ActionController::Caching::Sweeper
  observe Bus

  def after_save(bus)
    L.l bus
    L.l bus.name_changed?
    if bus.name_changed?
      L.l "Expiring cache!"
      expire_action controller: "/buses_images_generator", action: "show"
    end
  end
end