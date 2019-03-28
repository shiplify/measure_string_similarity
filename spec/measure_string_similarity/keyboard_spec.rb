require 'spec_helper'

RSpec.describe MeasureStringSimilarity::Keyboard do
  [
    # string 1          string 2            value     options
    [ nil,              '123 Main St',      0.0,      {} ],
    [ '123 Main St',    nil,                0.0,      {} ],
    [ nil,              nil,                1.0,      {} ],
    [ '123 Main St',    '123 Main St',      1.0,      {} ],
    [ '123 Main St',    '123 Nain St',      0.95,     {} ],
    [ '123 Main St',    '123 Zain St',      0.91,     {} ],
  ].each do |test_case|
    string1, string2, value, options = test_case
    it "returns #{value} when comparing #{string1} to #{string2} with options #{options.inspect}" do
      comparer = described_class.new(options)
      result = comparer.compare(string1, string2)
      expect(result).to be_within(0.01).of(value)
    end
  end
end

