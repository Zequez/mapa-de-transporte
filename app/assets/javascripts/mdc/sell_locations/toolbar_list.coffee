class MDC.SellLocations.ToolbarList extends MDC.Interface.Toggleable
  constructor: ->
    @settings_var = "show_sell_locations_list"
    @element      = "#sell-locations-list"
    super()