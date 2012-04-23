class AddDomainToCities < ActiveRecord::Migration
  def change
    add_column :cities, :domain, :string

  end
end
