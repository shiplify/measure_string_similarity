require 'spec_helper'

RSpec.describe MeasureStringSimilarity::Homoglyphs do
  [
    # string 1          string 2            value     options
    [ nil,              '123 Main St',      0.0,      {} ],
    [ '123 Main St',    nil,                0.0,      {} ],
    [ nil,              nil,                1.0,      {} ],
    [ '123 Main St',    '123 Main St',      1.0,      {} ],
    [ '123 Main St',    '123 Main 5t',      0.96,     {} ], # [ess]t <=> [five]t
    [ '123 Main St',    '123 Main Rt',      0.91,     {} ],
    [ '123 Main St',    'l23 Main St',      0.96,     {} ], # [one]23 <=> [ell]23
    [ '123 Main St',    'I23 Main St',      0.96,     {} ], # [one]23 <=> [eye]23
    [ '123 Main St',    'i23 Main St',      0.96,     {} ], # [one]23 <=> [eye]23
    [ '123 Main St',    '723 Main St',      0.91,     {} ],
    [ '1230 Main St',   '123O Main St',     0.96,     {} ], # 123[zero] <=> 123[oh]
    [ '1230 Main St',   '123D Main St',     0.94,     {} ], # 123[zero] <=> 123[dee]
    [ '123 Oat St',     '123 Dat St',       0.93,     {} ], # [oh]at <=> [dee]at
    [ '123 Oat St',     '123 Qat St',       0.93,     {} ], # [oh]at <=> [queue]at
    [ '123 Dat St',     '123 Qat St',       0.93,     {} ], # [dee]at <=> [queue]at
    [ '1230 Main St',   '1237 Main St',     0.91,     {} ],
    [ '123 Main St',    '1Z3 Main St',      0.96,     {} ], # 1[two]3 <=> 1[zee]3
    [ '123 Main St',    '193 Main St',      0.91,     {} ],
    [ '128 Main St',    '12B Main St',      0.94,     {} ], # 12[eight] <=> 12[bee]
    [ '128 Main St',    '127 Main St',      0.91,     {} ],
    [ '123 Lunn St',    '123 Lvnn St',      0.96,     {} ], # L[ewe]nn <=> L[vee]nn
    [ '123 Lunn St',    '123 Lann St',      0.91,     {} ],
    [ '123 Vonn St',    '123 Wonn St',      0.94,     {} ], # [vee]onn <=> [double-you]onn
    [ '123 Vonn St',    '123 Zonn St',      0.91,     {} ],
    [ '126 Main St',    '12G Main St',      0.94,     {} ], # 12[six] <=> 12[gee]
    [ '126 Main St',    '127 Main St',      0.91,     {} ],
    [ '123 Moon St',    '123 Noon St',      0.94,     {} ], # [emm]oon <=> [enn]oon
    [ '123 Moon St',    '123 Soon St',      0.91,     {} ],
    [ '123 Main St',    '12E Main St',      0.92,     {} ], # 12[three] <=> 12[eee]
    [ '123 Main St',    '12K Main St',      0.91,     {} ],
    [ '124 Main St',    '12A Main St',      0.94,     {} ], # 12[four] <=> 12[aye]
    [ '124 Main St',    '12K Main St',      0.91,     {} ],
  ].each do |test_case|
    string1, string2, value, options = test_case
    it "returns #{value} when comparing #{string1} to #{string2} with options #{options.inspect}" do
      comparer = described_class.new(options)
      result = comparer.compare(string1, string2)
      expect(result).to be_within(0.01).of(value)
    end
  end
end

