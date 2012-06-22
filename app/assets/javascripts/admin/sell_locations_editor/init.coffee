$ ->
  if $(document["body"]).is('.edit_sell_locations')
    new SellLocationsEditor.Manager window["sell_locations_editor_data"]