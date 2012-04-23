class AddAverageTimeToBuses < ActiveRecord::Migration
  def change
    add_column :buses, :average_time, :integer

  end
end
