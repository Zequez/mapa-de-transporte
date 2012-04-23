class AddDefaultToBusesColors < ActiveRecord::Migration
  def change
    change_column :buses, :color_1, :string, default: '#dddddd'
    change_column :buses, :color_2, :string, default: '#222222'
  end
end
