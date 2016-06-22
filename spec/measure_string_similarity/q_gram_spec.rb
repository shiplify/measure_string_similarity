require 'spec_helper'

RSpec.describe MeasureStringSimilarity::QGram do
  it 'initailizes a new object' do
    comparer = MeasureStringSimilarity::QGram.new
  end

  describe "expect QGram default " do
    it 'q to equal 3' do
      comparer = MeasureStringSimilarity::QGram.new
      expect(comparer.q).to eq(3)
    end

    it 'metric to equal dice' do
      comparer = MeasureStringSimilarity::QGram.new
      expect(comparer.metric).to eq('dice')
    end
  end
  [
    #     s1                   s2                           value                options
    [ 'P. Joostenstraat',      'P. Joostenstraat',           1.0 ,          {q: 3, metric: 'jaccard'}],
    [ 'P. Joostenstraat',      'P. Joostenstraat',           1.0 ,          {q: 2, metric: 'jaccard'}],
    [ 'P. Joostenstraat',      'P. Joostenstraat',           1.0 ,          {q: 3, metric: 'dice'}],
    [ 'P. Joostenstraat',      'P. Joostenstraat',           1.0 ,          {q: 2, metric: 'dice'}],
    [ 'P. Joostenstraat',      'P. Joostenstraat',           1.0 ,          {q: 3, metric: 'overlap'}],
    [ 'P. Joostenstraat',      'P. Joostenstraat',           1.0 ,          {q: 2, metric: 'overlap'}],
    [ 'P. Joostenstraat',      'Pieter Joostenstraat',      0.65          , {q: 3, metric: 'jaccard'}],
    [ '734 DELTA DR BLDG 710', '734 DELTA DR',               0.55,          {q: 2, metric: 'jaccard'}],
    [ '734 DELTA DR BLDG 710', '734 DELTA DR',               1.0,          {q: 2, metric: 'overlap'}],
    [ '734 DELTA DR BLDG 710', '734 DELTA DR',               0.73,          {q: 2, metric: 'dice'}],
    [ '4380 CARMAN DRIVE',     '4380 CARMAIN DR',            0.75,           {q: 3, metric: 'dice'}],
    [ '4380 CARMAN DRIVE',     '4380 CARMAIN DR',            0.71,           {q: 3, metric: 'jaccard'}],
    [ '5340 CARMAIN DR',       '4380 CARMAIN DR',            0.67,           {q: 3, metric: 'jaccard'}],
    [ '5340 CARMAIN DR',       '4380 CARMAIN DR',            0.67,           {q: 3, metric: 'dice'}],
  ].each do |test_case|
    s1, s2, value, options = test_case
    it "QGram returns #{value} for #{s1}, #{s2} when q is #{options[:q]} and metric is #{options[:metric]}" do
      comparer = MeasureStringSimilarity::QGram.new(options)
      result = comparer.compare(s1,s2)
      expect(result.round(2)).to eq(value)
    end
  end
end
