module ApplicationHelper
  def show_help_tips?
    !(@user_settings[:help_tips] === false)
  end

  def show_bus_info?
    !(@user_settings[:show_bus_info] === false)
  end

  def title
    @page_title ||= if sell_locations_in_url?
      if ticket_locations_in_url?
        t('views.head.title_ticket_locations', city: @city.name)
      else
        t('views.head.title_sell_locations', city: @city.name)
      end
    elsif @bus
      t('views.head.title_bus', bus: @bus.name, city: @city.name)
    elsif @city
      city_title
    else
      t('views.head.title')
    end
  end

  def city_title
    @city_title ||= t('views.head.title_city', city: @city.name)
  end

  def current_city_url
    @current_city_url ||= city_url(@city)
  end

  def description
    @page_description ||= if sell_locations_in_url?
      if ticket_locations_in_url?
        t('views.head.description_ticket_locations', city: @city.name)
      else
        t('views.head.description_sell_locations', city: @city.name)
      end
    elsif @bus
      t('views.head.description_bus', bus: @bus.name, city: @city.name)
    elsif @city
      t('views.head.description_city', city: @city.name)
    else
      t('views.head.description')
    end
  end

  def toolbar_toggler
    "<div class='toggle'>&#9660;</div>".html_safe
  end

  def share_button(title, href, width = 600, height = 300, &block)
    output = ""
    output += %{<a href="#{h href}"
    onclick="javascript:window.open(this.href, '', 'menubar=no,toolbar=no,resizable=yes,scrollbars=yes,height=#{height},width=#{width}');return false;"
    title="#{h title}">}
    if block_given?
      output += capture(&block)
    else
      output += h title
    end
    output +=  "</a>"
    output.html_safe
  end
end
