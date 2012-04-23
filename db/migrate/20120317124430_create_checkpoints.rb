class CreateCheckpoints < ActiveRecord::Migration
  def change
    create_table :checkpoints do |t|
      t.float :latitude
      t.float :longitude
      t.integer :target_id
      t.string :target_type
      t.integer :number
    end

    add_index :checkpoints, [:target_id, :target_type]
  end
end
