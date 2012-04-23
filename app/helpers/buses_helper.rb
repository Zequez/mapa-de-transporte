module BusesHelper
  def color_column(color)
    "<div style='height: 15px; background-color: #{color};'></div>".html_safe
  end

  def admin_routes_tabs
    @admin_routes_tabs ||= [:departure_route, :return_route].map do |route|
      link_to route.to_s.humanize, "##{route}", class: "#{route}_tab", onclick: "return false;"
    end.join
  end

  def checkpoints_inputs(form)
    base_name = form.object_name

    inputs = []

    form.object.checkpoints.each_index do |i|
      cp      = form.object.checkpoints[i]
      
      inputs << %w{id number latitude longitude}.map do |attr|
        "<input type='hidden'
                      name='#{base_name}[checkpoint_attributes][#{i}][#{attr}]'
                      value='#{h cp.send(attr)}'/>"
      end
    end

    inputs.flatten.join.html_safe
  end

  def bus_style(bus)
    colors = []
    colors << "background-color: #{bus.color_1}" unless bus.color_1.blank?
    colors << "color: #{bus.color_2}" unless bus.color_2.blank?
    {style: colors.join(';')}
  end

  def render_bus_group(bus_group)
    render partial: "bus_group", locals: {bus_group: bus_group, buses: bus_group.buses_cache}
  end

  def monetize(cents)
    "$%.2f" % (cents.to_f/100)
  end

  def monetize_bus(cents, cash, card)
    payment = []
    payment << "Efectivo" if cash
    payment << "Tarjeta"  if card
    
    "#{monetize(cents)} (#{payment.join(' y ').capitalize})"
  end

  def schedulize(from, to)
    times = [from, to].map do |time|
      hour = time/100
      minute = time-hour*100

      (Time.mktime(0)+hour*3600+minute*60).strftime("%l:%M%P")
    end

    "<span title='#{times.join ' a '}'>#{times.join '<br/>'}</span>".html_safe
  end

  def city_buses_path(city = false, buses)
    if buses.is_a? String
      param = buses
    else
      param = buses.sort_by(&:name).map(&:name).join('+')
    end
    
    city_url(city) + param
  end

  def bus_url_from_current_url(bus)
    buses = (bus.is_shown? ? @buses - [bus] : @buses + [bus])
    city_buses_path(buses)
  end

  def bus_link(bus, &block)
    buses = (bus.is_shown? ? @buses - [bus] : @buses + [bus]).sort_by(&:name).map(&:name)
    
    href  = city_buses_path(buses.join('+'))
    title = I18n.t('views.buses.show_buses_in_map', buses: buses.semantic_join)
  
    active = ("active" if bus.is_shown?)

    "<a href='#{href}' title='#{title}' class='slot bus #{active}' id='bus-#{bus.id}'>
      <div class='bus-name'>#{bus.name}</div>
    </a>".html_safe
  end

  private
end
