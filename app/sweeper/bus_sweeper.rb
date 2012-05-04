class BusSweeper < ActionController::Caching::Sweeper
  observe Bus

  def after_save(bus)
    expire_action controller: "buses_images_generator", action: "show"
  end
end