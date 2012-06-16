class AddPermToBuses < ActiveRecord::Migration
  def change
    add_column :buses, :perm, :string
    Bus.reset_column_information
    Bus.all.each do |bus|
      bus.save!
    end
  end
end
