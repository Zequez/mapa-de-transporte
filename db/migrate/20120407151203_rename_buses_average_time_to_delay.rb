class RenameBusesAverageTimeToDelay < ActiveRecord::Migration
  def change
    rename_column :buses, :average_time, :delay
  end
end
