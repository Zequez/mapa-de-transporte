class AddPolymorphicToRoutes < ActiveRecord::Migration
  def change
    add_column :routes, :routable_type, :string

    add_column :routes, :routable_id, :integer

  end
end
