class AddStartAndEndTimesToBuses < ActiveRecord::Migration
  def change
    add_column :buses, :start_time, :integer

    add_column :buses, :end_time, :integer

  end
end
