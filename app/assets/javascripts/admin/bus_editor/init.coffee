$ ->
  if $(document["body"]).is('.edit.admin_buses')
    new BusEditor.Bus window["bus_editor_data"]