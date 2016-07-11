require_relative "base"

module Makita
  module Filter
    class Enum < Base
      def conditions
        [
          "#{name} in (?)", value_to_ints
        ]
      end

      private

      def value_to_ints
        values.map{|string|
          enum[string.to_sym]
        }
      end

      def enum
        model.public_send(name.to_s.pluralize)
      end
    end
  end
end

