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
    elsif params[:origin] or params[:destination]
      if named_origin and named_destination
        t("views.directions.head.two", location_1: named_origin, location_2: named_destination)
      elsif named_origin
        t("views.directions.head.one", location: named_origin)
      elsif named_destination
        t("views.directions.head.one", location: named_destination)
      else
        if params[:origin] and params[:destination]
          t("views.directions.head.two_unnamed")
        else
          t("views.directions.head.one_unnamed")
        end
      end
    elsif @city
      city_title
    else
      t('views.head.title')
    end
  end

  def named_origin
    @named_origin ||= named_checkpoint :origin
  end

  def named_destination
    @named_destination ||= named_checkpoint :destination
  end

  def named_checkpoint(hash_key)
    if params[hash_key] and not (params[hash_key] =~ /^\[.*\]$/)
      params[hash_key].gsub("-", " ")
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

  def share_button(target, width = 600, height = 300)
    @share_urls ||= {
      facebook: "https://www.facebook.com/sharer.php?u=#{u current_city_url}&t=#{u city_title}",
      twitter: "https://twitter.com/intent/tweet?text=#{u city_title}&url=#{u current_city_url}%2F&via=#{CONFIG[:twitter_user]}",
      google: "https://plus.google.com/share?url=#{u current_city_url}"
    }

    text = h I18n.t("views.social.share_buttons.#{target}")

    %{<a href="#{h @share_urls[target]}" id="share-#{target}"
    onclick="javascript:window.open(this.href, '', 'menubar=no,toolbar=no,resizable=yes,scrollbars=yes,height=#{height},width=#{width}');return false;"
    title="#{text}"></a>}.html_safe
  end

  def follow_button(target)
    text = h I18n.t("views.social.follow_buttons.#{target}")
    
    %{<a id="follow-#{target}" title="#{text}" target="_blank" href="#{CONFIG[:social][target]}">#{text}</a>}.html_safe
  end

  def yes_no_collection
    @yes_no_null_collection ||= [
      [I18n.t('yep'), true],
      [I18n.t('nope'), false]
    ]
  end

  def custom_sell_locations_url
    if @city.show_bus_ticket
      ticket_locations_city_url
    else
      sell_locations_city_url
    end
  end
end
