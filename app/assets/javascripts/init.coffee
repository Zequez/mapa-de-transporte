city_path = location.pathname.match(/\/[^/]+/)
$.get "#{city_path}/qps", (result)->
  $ ->
    # Remove on production, just for testing.
    window.ASD = new MDC.Builder(result, true)