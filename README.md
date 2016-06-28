# measure_string_similarity

# Installing
  - Add `gem 'measure_string_similarity', git: 'https://github.com/shiplify/measure_string_similarity.git'` to Gemfile
  - JavaScript
    - Add `//=require measure-string-similarity` to application.js
    - Add whichever string comarison algorithms for list below to application.js 
      - ex. `//=require q-gram`
    - Add `'measureStringSimilarity'` to module requirements
      - ex. `angular.module('myApp' ['measureStringSimilarity'])`
    - Add string comparison service as requirement
      - ex. `angular.module('myApp').controller('myController', ['qGram'])`
  - Ruby
    - no extra steps are required
    
# Usage
  - JavaScript
    - Just type the name of the service and call `calculate` with two strings and options as the variables
      - ex. `qGram.calculate('123 Main St', '123 Main Street', {q: 3, metric: 'dice'})`
  
  - Ruby
    - Initalize the string comparison class with options then call compare with two strings
```ruby
comparer = MeasureStringSimilarity::QGram.new({q: 3, metric: 'dice'})
comparer.compare('123 Main St', '123 Main Street')
```

# String Comparisons
  - Levenshtein Distance
  
  - QGram
  

