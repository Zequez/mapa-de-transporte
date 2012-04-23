class CreateDomains < ActiveRecord::Migration
  def change
    create_table :domains do |t|
      t.string :name, unique: true
      t.integer :city_id
    end

    add_index :domains, :name
  end
end
