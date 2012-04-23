class SetBusesVisibleToFalse < ActiveRecord::Migration
  def up
    change_column :buses, :visible, :boolean, default: false, null: false
  end

  def down
    change_column :buses, :visible, :boolean, default: true, null: false
  end
end
