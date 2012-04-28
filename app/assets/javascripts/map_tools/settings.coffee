window.CONFIG = {
  max_path_finder_checkpoints: 2

  similar_routes_distance: 100 # Meters

  map_background_color: "#141414"
}

user_settings = {
  help_tips: true,
  max_walking_distance: 500,
  max_routes_suggestions: 1
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
    user_settings = $.cookie('settings')

    try
      @settings = _.extend @defaults, JSON.parse user_settings

    @read = @settings

  get: (setting_name)-> @settings[setting_name]
    

  set: (setting_name, value)->
    @settings[setting_name] = value
    @save()

  save: ->
    $.cookie 'settings', null
    $.cookie 'settings', JSON.stringify(@settings), {expires: 365, path: '/'}
    @read = @settings


window.SETTINGS = new UserSettings(user_settings)