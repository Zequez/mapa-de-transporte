# TODO: Add all the static classes and IDs here.

MDC.CONFIG = {
  # It allowed more than 2 before, now don't change this number or you may break something.
  # It's rather useless to have more than 2 anyway.
  max_path_finder_checkpoints: 2
  
  similar_routes_distance: 100 # Meters

  map_background_color: "#141414"
  
  url_buses_join: '+'

  settings_cookie: 'settings'

  max_walking_distance_min: 0
  max_walking_distance_max: 2980
}

user_settings = {
  "help_tips": true,
  "max_walking_distance": 1000,
  "max_routes_suggestions": 1,
  "show_bus_info": false
  "show_sell_locations_list": false
}

class UserSettings
  default: {},
  user_settings: {},
  settings: {}
  read: {}

  constructor: (defaults)->
    @defaults      = defaults
    @settings      = @default
    
    @load()

  load: ->
    user_settings = $.cookie(MDC.CONFIG.settings_cookie)

    try
      @settings = _.extend @defaults, JSON.parse user_settings

    @read = @settings

  get: (setting_name)-> @settings[setting_name]
    

  set: (setting_name, value)->
    @settings[setting_name] = value
    @save()

  save: ->
    $.cookie MDC.CONFIG.settings_cookie, null
    $.cookie MDC.CONFIG.settings_cookie, JSON.stringify(@settings), {expires: 365, path: '/'}
    @read = @settings


MDC.SETTINGS = new UserSettings(user_settings)