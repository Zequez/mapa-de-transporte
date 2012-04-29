# TODO: Using origin will always retrieve from the domain, not working with cities in paths. FIX THIS.
$.get document.location.origin + '/' + '.qps', (result)->
  $ -> new MDC.Builder(result, true)