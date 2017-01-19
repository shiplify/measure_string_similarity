require 'spec_helper'

RSpec.describe MeasureStringSimilarity::Levenshtein do
  it 'initailizes a new object' do
    comparer = MeasureStringSimilarity::Levenshtein.new
  end

  describe "default options" do
    it "sets metric to 'dice'" do
      comparer = MeasureStringSimilarity::Levenshtein.new
      expect(comparer.metric).to eq('dice')
    end
  end

  [
    # string 1          string 2            value     options
    [ '123 Main St',    '123 Main St',      1.0,      {} ],
    [ '123 Main St',    '423 Main St',      0.91,     {} ],
    [ '123 Main St',    '143 Main St',      0.91,     {} ],
    [ '123 Main St',    '124 Main St',      0.91,     {} ],
    [ '123 Main St',    '123 Main St',      1.0,      { metric: 'jaccard' } ],
    [ '123 Main St',    '123 Main St NW',   0.79,     { metric: 'jaccard' } ],
    [ '123 Main St',    '123 Main St',      1.0,      { metric: 'dice' } ],
    [ '123 Main St',    '123 Main St NW',   0.76,     { metric: 'dice' } ],
    [ '123 Main St',    '123 Main St',      1.0,      { metric: 'overlap' } ],
    [ '123 Main St',    '123 Main St NW',   0.72,     { metric: 'overlap' } ],
  ].each do |test_case|
    string1, string2, value, options = test_case
    it "returns #{value} when comparing #{string1} to #{string2} with options #{options.inspect}" do
      comparer = MeasureStringSimilarity::Levenshtein.new(options)
      result = comparer.compare(string1, string2)
      expect(result).to be_within(0.01).of(value)
    end
  end
end
