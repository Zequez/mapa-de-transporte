class AddUseAsDefaultToCities < ActiveRecord::Migration
  def change
    add_column :cities, :use_as_default, :boolean

  end
end
