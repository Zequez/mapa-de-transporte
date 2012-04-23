ActiveAdmin.register AdminUser do
  before_filter { @skip_sidebar = true }

  controller do
    before_filter :validate_superadmin, only: [:edit, :update]
    before_filter :just_superadmin, only: [:new, :create]

    def validate_superadmin
      return just_superadmin if resource != current_admin_user
      true
    end

    def just_superadmin
      unless current_admin_user.is_superadmin?
        render text: I18n.t('error_just_me', locale: :es)
        return false
      end
      true
    end
  end

  index do
    column :email
    column :current_sign_in_at
    column :last_sign_in_at
    column :sign_in_count
    default_actions
  end

  form do |f|
    f.inputs :email, :password
    f.buttons
  end
end
