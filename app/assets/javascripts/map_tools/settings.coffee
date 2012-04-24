default_settings = {
  max_buses_suggestions: 1
  max_path_finder_checkpoints: 2

  map_background_color: "#141414"
  default_path_finders_meters: 400
  max_path_finder_suggestion_extra_meters: 300
  max_path_finder_circles: 3


  help_tips: true

  filter_instructions: {
    start: true,
    many_zones: true,
    remove: true,
    no_buses: true,
    suggestion: true,
    maximum: true
  }
}

class PersistantSettings
  constructor: ->
    @settings = default_settings

  load: ->
    user_settings = $.cookie('settings')
    try
      @settings = _.extend @settings, JSON.parse user_settings
    @settings

  save: ->
    $.cookie 'settings', JSON.stringify(@settings), {expires: 365, path: '/'}

persistant_settings = new PersistantSettings
window.Settings      = persistant_settings.load()
window.SaveSettings  = -> persistant_settings.save()