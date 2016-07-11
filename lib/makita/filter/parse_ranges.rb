module Makita
  module Filter
    module ParseRanges
      def conditions
        ranges, simples = values.partition {|term| term[range_separator_re] }
        term_conditions = [simple_condition(simples)] + range_conditions(ranges)
        or_conditions(*term_conditions)
      end

      private

      def range_separator_re
        Regexp.union(sep_to_op_mapping.keys)
      end

      def sep_to_op_mapping
        {"~" => "<"}
      end

      def range_sep_to_op sep
        sep_to_op_mapping.fetch(sep)
      end

      def simple_condition values
        case values.count
        when 0
          nil
        when 1
          ["#{name} = ?", values.first]
        else
          ["#{name} in (?)", values]
        end
      end

      def range_conditions ranges
        ranges.map{|range| range_condition(range)}
      end

      def range_condition range
        left, right = range.split(range_separator_re)
        separator = range[range_separator_re]
        right_op = range_sep_to_op(separator)
        left_condition = ["(#{name} >= ?)", left] if left.present?
        right_condition = ["(#{name} #{right_op} ?)", right] if right.present?
        and_conditions(left_condition, right_condition)
      end
    end
  end
end
