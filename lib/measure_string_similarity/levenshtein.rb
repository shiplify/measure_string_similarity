module MeasureStringSimilarity
  class Levenshtein
    attr_reader :q, :metric

    def initialize(options = {})
      options = options || {}
      @metric = options.has_key?(:metric) && options[:metric] || 'dice'
    end

    # From https://rosettacode.org/wiki/Levenshtein_distance#Ruby
    def compare(a, b)
      str1 = a&.downcase
      str2 = b&.downcase
      return 1.0 if !str1 && !str2
      return 0.0 if str1.nil? || str2.nil?
      return 0.0 if str1.empty? || str2.empty?

      d = (0..str2.length).to_a
      edits = nil

      str1.each_char.with_index do |char1, i|
        e = i+1

        str2.each_char.with_index do |char2, j|
          substitution_cost = (char1 == char2) ? 0 : 1
          edits = [
            d[j+1] + 1, # insertion
            e + 1, # deletion
            d[j] + substitution_cost # substitution
          ].min
#           puts <<-TXT
# i=#{i}, j=#{j}, char1=#{char1}, char2=#{char2}
#   d = #{d.inspect}
#   edits = #{edits}
#   #{[(edits == d[j] && "no change"), (edits == d[j+1]+1 && "insertion"), (edits == e+1 && "deletion"), (edits == d[j]+substitution_cost && "substitution")].reject {|v| !v }.join(' || ')}
# TXT
          d[j] = e
          e = edits
        end

        d[str2.length] = edits
      end

      denominator = send("#{@metric}_value", str1, str2)
      val = (1.0 - (edits.to_f / denominator.to_f))
      [ val, 0.0 ].max
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

