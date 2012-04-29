module BusesImages
  ICONS_PATH = "#{File.dirname(__FILE__)}/buses_images/icons/"
  FIXED_TEXT_COLOR = "#000000"

  module BusInclude
    def self.included(base)
      base.extend ClassMethods
    end

    def handle_sprite_generation
      if CONFIG[:build_buses_sprite_on_demand]
        Bus.delete_sprite
      else
        generate_icon
        Bus.generate_sprite
      end
    end

    def generate_icon
      if not BusesImages::Icon.new(name, background_color, text_color).save(icon_path)
        raise "Error creating image" if not $?.success?
      end
      true
    end

    def icon_path
      (Rails.root + CONFIG[:bus_icon_path]).to_s.sub(':id', id.to_s)
    end

    module ClassMethods
      def rebuild_sprite
        all.each(&:generate_icon)
        generate_sprite
      end

      def generate_sprite
        if not BusesImages::Sprite.new(icons_path).save(sprite_path)
          raise "Error creating the montaged image" if not $?.success?
        end
        true
      end

      def delete_sprite
        FileUtils.rm sprite_path if File.exists?(sprite_path)
      end

      def icons_path
        (Rails.root + CONFIG[:bus_icons_path]).to_s
      end

      def sprite_path
        CONFIG[:buses_sprite_path]
      end
    end
  end

  extend ActiveSupport::Autoload

  autoload :BaseImageMagick
  autoload :Icon
  autoload :Sprite
end