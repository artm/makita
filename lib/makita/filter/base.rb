module Makita
  module Filter
    class Base
      attr_reader :axis, :filter_value
      delegate :model, :name, to: :axis

      def initialize axis, filter_value
        @axis = axis
        @filter_value = filter_value
      end

      def apply relation
        relation.where(*conditions)
      end

      def report_filter_value
        filter_value
      end

      protected

      def values
        if filter_value.is_a? Array
          filter_value
        else
          [filter_value]
        end
      end

      # expect each condition in the form [string, *optional_args]
      # will remove nils, returns a single [string, *args]
      def join_conditions op, *conditions
        conditions = conditions.compact
        if conditions.empty?
          conditions
        elsif conditions.count == 1
          conditions.first
        else
          strings = conditions.map(&:first)
          args = conditions.flat_map{|c| c[1..-1]}
          [
            strings.map{|s| "(#{s})"}.join(" #{op} "),
            *args
          ]
        end
      end

      def or_conditions *conditions
        join_conditions "OR", *conditions
      end

      def and_conditions *conditions
        join_conditions "AND", *conditions
      end
    end
  end
end

