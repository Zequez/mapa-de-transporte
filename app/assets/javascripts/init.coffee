# TODO: Using origin will always retrieve from the domain, not working with cities in paths. FIX THIS.

$.get "http://#{document.location.host}/qps", (result)->
  $ -> new MDC.Builder(result, true)