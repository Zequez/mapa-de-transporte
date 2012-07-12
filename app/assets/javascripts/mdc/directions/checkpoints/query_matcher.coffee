class MDC.Directions.Checkpoints.QueryMatcher
  constructor: (@query)->
    @query  = @sanitize(@query)
    @string = @query
    @length = @query.length
    @query
    @hard   = new RegExp("^" + query, "i")
    @soft   = new RegExp(query, "i")

  sanitize: (query)->
    query.replace(/[^a-z 0-9]/, "")

  match: (option)->
    if option[0].match @hard
      @make_result(option, true)
    else if option[0].match @soft
      @make_result(option, false)
    else
      false

  rematch: (result)->
    if result.option[0].match @hard
      result.update @highlight(result.option), true
      true
    else if result.option[0].match @soft
      result.update @highlight(result.option), false
      true
    else
      false

  just_match: (option, hard = true)->
    if hard
      option[0].match @hard
    else
      option[0].match @soft


  make_result: (option, hard)->
     new MDC.Directions.Checkpoints.AutocompleteResult(option, @highlight(option), hard)

  highlight: (option)->
    name  = option[0]
    start = name.search @soft
    end   = start + @length

    name = name.slice(0, start) +
           "<b>" +
           name.slice(start, end) +
           "</b>" +
           name.slice(end)