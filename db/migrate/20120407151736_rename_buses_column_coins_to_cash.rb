class RenameBusesColumnCoinsToCash < ActiveRecord::Migration
  def change
    rename_column :buses, :coins, :cash
  end
end
