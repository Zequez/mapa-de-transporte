class Normalizer
  def initialize(value)
    @value = value
  end

  def perm
    @perm ||= normal.gsub(' ', '-')
  end

  def clean
    @clean ||= @value.gsub(Regexp.new("[^#{CONFIG[:tag][:valid_chars]}]", 'i'), ' ').strip.squeeze(' ').to_s
  end

  def normal
    @normal ||= @value.mb_chars.normalize(:kd).gsub(/[^\x00-\x7F]/u,'').downcase.gsub(/[^a-z0-9]/, ' ').strip.squeeze(' ').to_s
  end

  def list
    list = @value
    .to_s.split(CONFIG[:tag][:separator].strip)
    .map{|v|Normalizer.clean(v)}
    .inject([]){|li, v| li << v if not v.blank?; li }

    downcased = []
    list.inject([]) do |result, elem|
      if not downcased.include? ele = Normalizer.normal(elem)
        result << elem
        downcased << ele
      end
      result
    end
  end

  def substract_list(list)
    downcased_list   = list.collect{|item| Normalizer.normal item}
    downcased_target = @value.collect{|item| Normalizer.normal item}
    
    target = @value.dup
    downcased_list.each do |list_item|
      index = downcased_target.index(list_item)
      target[index] = nil
    end

    target.compact
  end

  def to_s
    @value
  end

  class << self
    def perm(value)
      new(value).perm
    end

    def clean(value)
      new(value).clean
    end

    def normal(value)
      new(value).normal
    end

    def list(value)
      new(value).list
    end

    def substract_list(value1, value2)
      new(value1).substract_list(value2)
    end
  end
end