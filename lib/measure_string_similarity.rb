module MeasureStringSimilarity
  VERSION = "0.0.14"
  require 'measure_string_similarity/q_gram'
  require 'measure_string_similarity/levenshtein'
  if defined? ::Rails::Engine
    require "measure_string_similarity/engine"
  elsif defined? Sprockets
    require "measure_string_similarity/sprockets"
  end
end
