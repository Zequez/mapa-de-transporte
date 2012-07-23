class AddVisibilityToCities < ActiveRecord::Migration
  def change
    add_column :cities, :visible, :boolean, null: false, default: false

  end
end
