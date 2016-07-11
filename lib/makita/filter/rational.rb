require_relative "base"
require_relative "comma_separated_ranges"

module Makita
  module Filter
    class Rational < Base
      include CommaSeparatedRanges
    end
  end
end
