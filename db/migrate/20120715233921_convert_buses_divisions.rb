class ConvertBusesDivisions < ActiveRecord::Migration
  def up
    regex = /[ABCDEFGHIJK+?]\Z/
    
    Bus.all.each do |bus|
      if (match = bus.name.match(regex))
        bus.name     = bus.name.gsub(regex, "")
        bus.division = match.to_s
        bus.save!
      end
    end
  end
end
