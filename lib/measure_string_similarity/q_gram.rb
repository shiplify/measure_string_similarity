module MeasureStringSimilarity
  class QGram

    attr_reader :q, :metric

    def initialize(options = {})
      options = options || {}
      @q = options.has_key?(:q) && options[:q] ||  3
      @metric = options.has_key?(:metric) && options[:metric] || 'dice'
    end

    def compare(s1, s2)
      _qgrams(s1, s2, q, metric)
    end

    private

    def _qgrams(s1, s2, q, measure)
      return 1.0 if !s1 && !s2
      return 0.0 if !s1 || !s2

      s1_gram_array = _gramify(s1, q)
      s2_gram_array = _gramify(s2, q)

      send("#{measure}_value", s1_gram_array, s2_gram_array)
    end

    def _gramify(string, num_chars)
      gram_array = []
      # front padded
      padding = Array.new(num_chars - 1, '_')
      character_array = padding + string.chars

      character_array.each_cons(num_chars) { |v| gram_array << v.join('') }
      gram_array.uniq
    end

    def jaccard_value(s1_array, s2_array)
      max_count = [s1_array.length, s2_array.length].max
      similarity_count = (s1_array & s2_array).size

      similarity_count.to_f / max_count
    end

    def dice_value(s1_array, s2_array)
      average_count = (s1_array.length + s2_array.length).to_f / 2
      similarity_count = (s1_array & s2_array).size

      similarity_count.to_f / average_count
    end

    def overlap_value(s1_array, s2_array)
      min_count = [s1_array.length, s2_array.length].min
      similarity_count = (s1_array & s2_array).size

      similarity_count.to_f / min_count
    end
  end
end

