class MakeFirstUserSuperadmin < ActiveRecord::Migration
  def up
    AdminUser.first.update_column :is_superadmin, true
  end

  def down
    AdminUser.first.update_column :is_superadmin, false
  end
end
