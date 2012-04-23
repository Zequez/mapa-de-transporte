class CreateRoutes < ActiveRecord::Migration
  def change
    create_table :routes do |t|
      t.string :name
    end

    add_column :buses, :departure_route_id, :integer
    add_column :buses, :return_route_id, :integer
    rename_column :checkpoints, :target_id, :route_id
    remove_column :checkpoints, :target_type
  end
end
