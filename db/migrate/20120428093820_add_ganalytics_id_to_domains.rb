class AddGanalyticsIdToDomains < ActiveRecord::Migration
  def change
    add_column :domains, :google_analytics_id, :string

  end
end
