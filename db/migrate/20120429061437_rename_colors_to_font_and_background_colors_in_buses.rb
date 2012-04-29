class RenameColorsToFontAndBackgroundColorsInBuses < ActiveRecord::Migration
  def change
    rename_column :buses, :color_1, :background_color
    rename_column :buses, :color_2, :text_color
  end
end
