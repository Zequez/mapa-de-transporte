$.get document.location.href.replace(/\/$/, '') + '.qps', (result)->
  $ -> new City(JSON.parse result)