describe 'LevenshteinDistance', ->
  beforeEach module('measureStringSimilarity')
  levenshteinDistance = null

  beforeEach inject (_levenshteinDistance_) ->
    levenshteinDistance = _levenshteinDistance_
  for some_text in [
    ['111 3rd St', 1.0],
    ['111 Third St', 0.86],
    ['111 3rd Street', 0.83],
    ['111 Third Street', 0.73]
    ['', 0]
  ]
    describe "levinstein distance", ->
      [geocoded, expected] = some_text
      source = '111 3rd St'
      it "calculates similarity properly", ->
        actual = levenshteinDistance.calculate(source, geocoded)
        expect(actual).toEqual expected

