module MeasureStringSimilarity
  class Levenshtein
    attr_reader :q, :metric

    def initialize(options = {})
      options = options || {}
      @metric = options.has_key?(:metric) && options[:metric] || 'dice'
    end

    def compare(a, b)
      return 1.0 if !a && !b
      return 0.0 if !a || !b
      return 1.0 if a == b
      return 1.0 if a.length == 0
      return 1.0 if b.length == 0

      matrix = []
      i = 0
      while i <= b.length do
        matrix[i] = [i]
        i = i + 1
      end

      j = 0
      while j <= a.length do
        matrix[0][j] = j
        j = j + 1
      end

      i = 1
      while i <= b.length do
        j = 1
        while j <= a.length do
          if b[i - 1] == a[j - 1]
            matrix[i][j] = matrix[i - 1][j - 1]
          else
            matrix[i][j] = [
              matrix[i - 1][j - 1] + 1,
              [
                matrix[i][j - 1] + 1,
                matrix[i - 1][j] + 1
              ].min
            ].min
          end
          j = j + 1
        end
        i = i + 1
      end
      edits = matrix[b.length][a.length]
      denominator = send("#{@metric}_value", a, b)
      (1.0 - (edits.to_f / denominator.to_f))
    end

    private


    def jaccard_value(a, b)
      [ a.length, b.length ].max
    end

    def dice_value(a, b)
      (a.length + b.length) / 2.0
    end

    def overlap_value(a, b)
      [ a.length, b.length ].min
    end
  end
end

