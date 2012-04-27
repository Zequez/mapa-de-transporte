module ApplicationHelper
  def show_help_tips?
    cookies[:help_tips] != 'false'
  end

  def title
    @page_title ||= if @bus
      t('views.head.title_bus', bus: @bus.name, city: @city.name)
    elsif @city
      t('views.head.title_city', city: @city.name)
    else
      t('views.head.title')
    end
  end

  def description
    @page_description ||= if @bus
      t('views.head.description_bus', bus: @bus.name, city: @city.name)
    elsif @city
      t('views.head.description_city', city: @city.name)
    else
      t('views.head.description')
    end
  end

  def url
    
  end
end
