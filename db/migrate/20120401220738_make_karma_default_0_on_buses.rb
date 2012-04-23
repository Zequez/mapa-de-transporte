class MakeKarmaDefault0OnBuses < ActiveRecord::Migration
  def up
    change_column :buses, :karma, :integer, default: 0, null: false
  end
end
