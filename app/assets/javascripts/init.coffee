city_path = location.pathname.match(/\/[^/]+/)
$.get "#{city_path}/qps", (result)->
  $ -> new MDC.Builder(result, true)