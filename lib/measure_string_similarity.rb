module MeasureStringSimilarity
  VERSION = '0.4.6'

  require 'measure_string_similarity/q_gram'
  require 'measure_string_similarity/levenshtein'
  require 'measure_string_similarity/keyboard'
  require 'measure_string_similarity/homoglyphs'

  if defined? ::Rails::Engine
    require "measure_string_similarity/engine"
  elsif defined? Sprockets
    require "measure_string_similarity/sprockets"
  end
end
