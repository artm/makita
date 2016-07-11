require_relative "base"

module Makita
  module Filter
    class Bitmask < Base
      def apply relation
        relation = relation
          .public_send("with_#{name}", *in_values) if in_values.present?
        relation = relation
          .public_send("without_#{name}", *out_values) if out_values.present?
        relation
      end

      private

      def in_values
        values.reject{|value| value[/^~/]}
      end

      def out_values
        values
          .select{|value| value[/^~/]}
          .map{|value| value[1..-1]}
      end
    end
  end
end
