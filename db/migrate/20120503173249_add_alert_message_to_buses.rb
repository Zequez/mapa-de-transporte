class AddAlertMessageToBuses < ActiveRecord::Migration
  def change
    add_column :buses, :alert_message, :string

  end
end
