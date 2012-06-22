class AddPaperclipToSellLocations < ActiveRecord::Migration
  def self.up
    add_attachment :sell_locations, :picture
  end

  def self.down
    remove_attachment :sell_locations, :picture
  end
end
