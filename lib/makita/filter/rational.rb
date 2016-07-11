require_relative "base"
require_relative "parse_ranges"

module Makita
  module Filter
    class Rational < Base
      include ParseRanges
    end
  end
end
