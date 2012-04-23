class AddIsSuperadminToAdminUser < ActiveRecord::Migration
  def change
    add_column :admin_users, :is_superadmin, :boolean, default: false
  end
end
