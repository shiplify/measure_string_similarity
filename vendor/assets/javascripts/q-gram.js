var myApp = angular.module('measureStringSimilarity')

//service style, probably the simplest one
myApp.service('qGram', function() {
    var gramify = function(string, q) {
      var gram_array = []
      var padding = Array.apply(null, Array(q-1)).map(function () { return '_'; })
      var character_array = padding.concat(string.split(''))
      return each_cons(character_array, q).filter( onlyUnique )
    };
    var range = function (a, i, n) {
      var r = []
      for (var j = 0; j < n; j++) {
        r.push(a[i + j])
      }
      return r
    };

    var each_cons = function (a, n) {
      var r = []
      for (var i = 0; i < a.length - n + 1; i++) {
        r.push(range(a, i, n).join(''))
      }
      return r
    };

    var onlyUnique = function (value, index, self) {
      return self.indexOf(value) === index;
    };

    this.calculate = function(a, b, options) {
      options = typeof options !== 'undefined' ? options : {}
      q = options['q'] || 3
      metric = options['metric'] || 'dice'
      if (a === b) {
        return 1.0;
      }
      if (a.length === 0) {
        return 0;
      }
      if (b.length === 0) {
        return 0;
      }
      var a_gram_array = gramify(a, q)
      var b_gram_array = gramify(b, q)
      var similarity_count = a_gram_array.filter(function(n) {
        return b_gram_array.indexOf(n) != -1;
      }).length;
      var denominator = null
      switch(metric) {
        case 'dice':
          denominator = (a_gram_array.length + b_gram_array.length)/2
          break;
        case 'jaccard':
          denominator = Math.max(a_gram_array.length, b_gram_array.length)
          break;
        case 'overlap':
          denominator = Math.min(a_gram_array.length, b_gram_array.length)
          break;
      }
      return Math.round((similarity_count / denominator)*100)/100
    };
});

