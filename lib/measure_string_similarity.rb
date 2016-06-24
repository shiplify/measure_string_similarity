require 'measure_string_similarity/q_gram'
module MeasureStringSimilarity
  VERSION = "0.0.2"
  if defined? ::Rails::Engine
    require "angularjs-rails/engine"
  elsif defined? Sprockets
    require "angularjs-rails/sprockets"
  end
end
