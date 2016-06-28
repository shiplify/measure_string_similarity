describe 'QGram', ->
  beforeEach module('measureStringSimilarity')
  qGram = null

  beforeEach inject (_qGram_) ->
    qGram = _qGram_
  for test_case in [
    #     s1                   s2                           expected                options
    [ 'P. Joostenstraat',      'P. Joostenstraat',           1.0 ,          {q: 3, metric: 'jaccard'}],
    [ 'P. Joostenstraat',      'P. Joostenstraat',           1.0 ,          {q: 2, metric: 'jaccard'}],
    [ 'P. Joostenstraat',      'P. Joostenstraat',           1.0 ,          {q: 3, metric: 'dice'}],
    [ 'P. Joostenstraat',      'P. Joostenstraat',           1.0 ,          {q: 2, metric: 'dice'}],
    [ 'P. Joostenstraat',      'P. Joostenstraat',           1.0 ,          {q: 3, metric: 'overlap'}],
    [ 'P. Joostenstraat',      'P. Joostenstraat',           1.0 ,          {q: 2, metric: 'overlap'}],
    [ 'P. Joostenstraat',      'Pieter Joostenstraat',      0.65          , {q: 3, metric: 'jaccard'}],
    [ 'P. Joostenstraat',      'Pieter Joostenstraat',      0.72          , {q: 2, metric: 'jaccard'}],
    [ '734 DELTA DR BLDG 710', '734 DELTA DR',               0.55,          {q: 2, metric: 'jaccard'}],
    [ '734 DELTA DR BLDG 710', '734 DELTA DR',               1.0,          {q: 2, metric: 'overlap'}],
    [ '734 DELTA DR BLDG 710', '734 DELTA DR',               0.71,          {q: 2, metric: 'dice'}],
    [ '4380 CARMAN DRIVE',     '4380 CARMAIN DR',            0.75,           {q: 3, metric: 'dice'}],
    [ '4380 CARMAN DRIVE',     '4380 CARMAIN DR',            0.75],
    [ '4380 CARMAN DRIVE',     '4380 CARMAIN DR',            0.71,           {q: 3, metric: 'jaccard'}],
    [ '5340 CARMAIN DR',       '4380 CARMAIN DR',            0.67,           {q: 3, metric: 'jaccard'}],
    [ '5340 CARMAIN DR',       '4380 CARMAIN DR',            0.67,           {q: 3, metric: 'dice'}],
  ]
    describe 'q-grams', ->
      [s1, s2, expected, options] = test_case
      it "returns #{expected} for #{s1} and #{s2}", ->
        actual = qGram.calculate(s1, s2, options)
        expect(actual).toEqual expected
