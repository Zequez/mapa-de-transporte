class AddVisibilityToBuses < ActiveRecord::Migration
  def change
    add_column :buses, :visible, :boolean, default: true, null: false

  end
end
