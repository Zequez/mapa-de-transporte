class AddCityIdToFeedback < ActiveRecord::Migration
  def change
    add_column :feedbacks, :city_id, :integer

  end
end
