require_relative "base"
require_relative "comma_separated_ranges"

module Makita
  module Filter
    class Cardinal < Base
      include CommaSeparatedRanges

      private

      def sep_to_op_mapping
        super.merge("-" => "<=")
      end
    end
  end
end
