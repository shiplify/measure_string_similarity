module MeasureStringSimilarity
  VERSION = "0.0.11"
  require 'measure_string_similarity/q_gram'
  if defined? ::Rails::Engine
    require "measure_string_similarity/engine"
  elsif defined? Sprockets
    require "measure_string_similarity/sprockets"
  end
end
