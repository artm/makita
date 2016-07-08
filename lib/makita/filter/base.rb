module Makita
  module Filter
    class Base
      attr_reader :axis, :filter_value

      def initialize axis, filter_value
        @axis = axis
        @filter_value = filter_value
      end

      def apply relation
        relation.where(*conditions)
      end

      def conditions
        [ axis.name => filter_value ]
      end
    end
  end
end

