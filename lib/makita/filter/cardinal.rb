require_relative "base"
require_relative "parse_ranges"

module Makita
  module Filter
    class Cardinal < Base
      include ParseRanges

      private

      def sep_to_op_mapping
        super.merge("-" => "<=")
      end
    end
  end
end
