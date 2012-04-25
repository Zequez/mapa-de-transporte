module ApplicationHelper
  def show_help_tips?
    cookies[:help_tips] != 'false'
  end
end
