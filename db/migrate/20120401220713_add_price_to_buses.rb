class AddPriceToBuses < ActiveRecord::Migration
  def change
    add_column :buses, :price, :integer
    add_column :buses, :card, :boolean, default: true, null: false
    add_column :buses, :coins, :boolean, default: false, null: false
  end
end
