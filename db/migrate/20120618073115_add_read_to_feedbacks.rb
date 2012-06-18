class AddReadToFeedbacks < ActiveRecord::Migration
  def change
    add_column :feedbacks, :read, :boolean, default: false, null: false

  end
end
