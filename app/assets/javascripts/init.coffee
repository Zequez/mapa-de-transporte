city_path = location.pathname.match(/\/[^/]+/)
$.get "#{city_path}/qps?#{window["cache_time"]}", (result)->
  $ ->
    new MDC.Builder(result, true)