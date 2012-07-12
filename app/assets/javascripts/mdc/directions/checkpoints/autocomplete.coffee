class MDC.Directions.Checkpoints.Autocomplete
  constructor: (@list)->
    @results     = {}
#    @checkpoints_results = {}
#    @checkpoints_results[""] = @checkpoints

  query: (raw_query, previous_results)->
    return [] if not raw_query
#    return @results[raw_query] if @results[raw_query]

    query = new MDC.Directions.Checkpoints.QueryMatcher(raw_query)
    
    hard_results = []
    soft_results = []

    if previous_results
      for result in previous_results
        if query.rematch result
          if result.hard
            hard_results.push result
          else
            soft_results.push result
        else
          result.destroy()
    else
      for option in @list
        result = query.match option
        if result
          if result.hard
            hard_results.push result
          else
            soft_results.push result

    hard_results = @sort_results hard_results
    soft_results = @sort_results soft_results

#    @results[query] = hard_results.concat soft_results
    hard_results.concat soft_results

  match_unique: (raw_query)->
    query = new MDC.Directions.Checkpoints.QueryMatcher(raw_query)

    for result in @list
      if query.just_match result, true
        return result

    for result in @list
      if query.just_match result, false
        return result

    false


  sort_results: (results)->
    results.sort (result_a, result_b)->
      result_a.option[0] - result_b.option[0]




