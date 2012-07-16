class AddDivisionToBuses < ActiveRecord::Migration
  def change
    add_column :buses, :division, :string

    add_column :buses, :division_name, :string

  end
end
