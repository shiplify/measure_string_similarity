module MeasureStringSimilarity
  class Homoglyphs < Levenshtein
    COST_REALLY_SIMILAR = 0.4
    COST_SOMEWHAT_SIMILAR = 0.7
    COST_SLIGHTLY_SIMILAR = 0.9

    def initialize(options = {})
      super options.merge(costs: self.class.costs)
    end

    def self.costs
      [
        [ '1', 'i', COST_REALLY_SIMILAR ],
        [ '1', 'l', COST_REALLY_SIMILAR ],
        [ 'i', 'l', COST_REALLY_SIMILAR ],
        [ '5', 's', COST_REALLY_SIMILAR ],
        [ 'o', '0', COST_REALLY_SIMILAR ],
        [ 'o', 'q', COST_SOMEWHAT_SIMILAR ],
        [ 'o', 'd', COST_SOMEWHAT_SIMILAR ],
        [ '0', 'q', COST_SOMEWHAT_SIMILAR ],
        [ '0', 'd', COST_SOMEWHAT_SIMILAR ],
        [ 'q', 'd', COST_SOMEWHAT_SIMILAR ],
        [ 'z', '2', COST_REALLY_SIMILAR ],
        [ 'u', 'v', COST_REALLY_SIMILAR ],
        [ 'v', 'w', COST_SOMEWHAT_SIMILAR ],
        [ 'b', '8', COST_SOMEWHAT_SIMILAR ],
        [ '6', 'g', COST_SOMEWHAT_SIMILAR ],
        [ 'm', 'n', COST_SOMEWHAT_SIMILAR ],
        [ '4', 'a', COST_SOMEWHAT_SIMILAR ],
        [ '3', 'e', COST_SLIGHTLY_SIMILAR ],
      ].reduce({}) do |memo, row|
        char1, char2, cost = row
        {}.merge(memo).tap do |mapping|
          mapping[char1] ||= {}
          mapping[char1][char2] = cost
          mapping[char2] ||= {}
          mapping[char2][char1] = cost
        end
      end
    end
  end
end

