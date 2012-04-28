$.get document.location.origin + '/' + '.qps', (result)->
  $ -> new City(JSON.parse result)