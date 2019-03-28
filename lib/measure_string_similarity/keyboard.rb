module MeasureStringSimilarity
  class Keyboard < Levenshtein
    COST_ADJACENT = 0.5

    def initialize(options = {})
      super options.merge(costs: self.class.costs)
    end

    def self.costs
      [
        [ '1', '2', COST_ADJACENT ],
        [ '1', 'q', COST_ADJACENT ],
        [ '2', '3', COST_ADJACENT ],
        [ '2', 'w', COST_ADJACENT ],
        [ '2', 'q', COST_ADJACENT ],
        [ '3', '4', COST_ADJACENT ],
        [ '3', 'e', COST_ADJACENT ],
        [ '3', 'w', COST_ADJACENT ],
        [ '4', '5', COST_ADJACENT ],
        [ '4', 'r', COST_ADJACENT ],
        [ '4', 'e', COST_ADJACENT ],
        [ '5', '6', COST_ADJACENT ],
        [ '5', 't', COST_ADJACENT ],
        [ '5', 'r', COST_ADJACENT ],
        [ '6', '7', COST_ADJACENT ],
        [ '6', 'y', COST_ADJACENT ],
        [ '6', 't', COST_ADJACENT ],
        [ '7', '8', COST_ADJACENT ],
        [ '7', 'u', COST_ADJACENT ],
        [ '7', 'y', COST_ADJACENT ],
        [ '8', '9', COST_ADJACENT ],
        [ '8', 'i', COST_ADJACENT ],
        [ '8', 'u', COST_ADJACENT ],
        [ '9', '0', COST_ADJACENT ],
        [ '9', 'o', COST_ADJACENT ],
        [ '9', 'i', COST_ADJACENT ],
        [ '0', 'p', COST_ADJACENT ],
        [ '0', 'o', COST_ADJACENT ],
        [ 'q', 'w', COST_ADJACENT ],
        [ 'q', 'a', COST_ADJACENT ],
        [ 'w', 'e', COST_ADJACENT ],
        [ 'w', 's', COST_ADJACENT ],
        [ 'w', 'a', COST_ADJACENT ],
        [ 'e', 'r', COST_ADJACENT ],
        [ 'e', 'd', COST_ADJACENT ],
        [ 'e', 's', COST_ADJACENT ],
        [ 'r', 't', COST_ADJACENT ],
        [ 'r', 'f', COST_ADJACENT ],
        [ 'r', 'd', COST_ADJACENT ],
        [ 't', 'y', COST_ADJACENT ],
        [ 't', 'g', COST_ADJACENT ],
        [ 't', 'f', COST_ADJACENT ],
        [ 'y', 'u', COST_ADJACENT ],
        [ 'y', 'h', COST_ADJACENT ],
        [ 'y', 'g', COST_ADJACENT ],
        [ 'u', 'i', COST_ADJACENT ],
        [ 'u', 'j', COST_ADJACENT ],
        [ 'u', 'h', COST_ADJACENT ],
        [ 'i', 'o', COST_ADJACENT ],
        [ 'i', 'k', COST_ADJACENT ],
        [ 'i', 'j', COST_ADJACENT ],
        [ 'o', 'p', COST_ADJACENT ],
        [ 'o', 'l', COST_ADJACENT ],
        [ 'o', 'k', COST_ADJACENT ],
        [ 'p', 'l', COST_ADJACENT ],
        [ 'a', 's', COST_ADJACENT ],
        [ 'a', 'z', COST_ADJACENT ],
        [ 's', 'd', COST_ADJACENT ],
        [ 's', 'x', COST_ADJACENT ],
        [ 's', 'z', COST_ADJACENT ],
        [ 'd', 'f', COST_ADJACENT ],
        [ 'd', 'c', COST_ADJACENT ],
        [ 'd', 'x', COST_ADJACENT ],
        [ 'f', 'g', COST_ADJACENT ],
        [ 'f', 'v', COST_ADJACENT ],
        [ 'f', 'c', COST_ADJACENT ],
        [ 'g', 'h', COST_ADJACENT ],
        [ 'g', 'b', COST_ADJACENT ],
        [ 'g', 'v', COST_ADJACENT ],
        [ 'h', 'j', COST_ADJACENT ],
        [ 'h', 'n', COST_ADJACENT ],
        [ 'h', 'b', COST_ADJACENT ],
        [ 'j', 'k', COST_ADJACENT ],
        [ 'j', 'm', COST_ADJACENT ],
        [ 'j', 'n', COST_ADJACENT ],
        [ 'k', 'l', COST_ADJACENT ],
        [ 'k', 'm', COST_ADJACENT ],
        [ 'z', 'x', COST_ADJACENT ],
        [ 'x', 'c', COST_ADJACENT ],
        [ 'c', 'v', COST_ADJACENT ],
        [ 'v', 'b', COST_ADJACENT ],
        [ 'b', 'n', COST_ADJACENT ],
        [ 'n', 'm', COST_ADJACENT ],
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

