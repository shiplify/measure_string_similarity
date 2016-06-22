module MeasureStringSimilarity
  class << self
    def trigram_jaccard(s1, s2)
      _qgrams(s1, s2, 3, 'jaccard')
    end

    def bigram_jaccard(s1, s2)
      _qgrams(s1, s2, 2, 'jaccard')
    end

    def trigram_dice(s1, s2)
      _qgrams(s1, s2, 3, 'dice')
    end

    def bigram_dice(s1, s2)
      _qgrams(s1, s2, 2, 'dice')
    end

    def trigram_overlap(s1, s2)
      _qgrams(s1, s2, 3, 'overlap')
    end

    def bigram_overlap(s1, s2)
      _qgrams(s1, s2, 2, 'overlap')
    end

    private

    def _qgrams(s1, s2, q, measure)
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
      gram_array
    end

    def jaccard_value(s1_array, s2_array)
      max_count = [s1_array.length, s2_array.length].max
      similarity_count = (s1_array & s2_array).size

      similarity_count.to_f / max_count
    end

    def dice_value(s1_array, s2_array)
      average_count = (s1_array.length + s2_array.length) / 2
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
