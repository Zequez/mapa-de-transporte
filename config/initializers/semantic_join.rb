class Array
  def semantic_join(comma = ', ')
    return self[0] if size == 1
    return ''      if size == 0
    [self[0..-2].join(comma), self[-1]].join(" #{I18n.t('and')} ")
  end
end