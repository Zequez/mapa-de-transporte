class DisallowNullFromBusesCardAndCash < ActiveRecord::Migration
  def up
    change_column :buses, :cash, :boolean, default: nil, null: true
    change_column :buses, :card, :boolean, default: nil, null: true
  end

  def down
    change_column :buses, :cash, :boolean, default: false, null: false
    change_column :buses, :card, :boolean, default: false, null: false
  end
end
