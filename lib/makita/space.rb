require_relative "axis"

module Makita
  class Space
    def initialize full_set, filters: []
      @full_set = full_set
      self.filters = filters
    end

    def filtered
      filters.reduce(@full_set) { |subset, filter|
        filter.apply(subset)
      }
    end

    def filters= filter_params
      @filters = axes.map { |axis|
        axis.make_filter(filter_params)
      }.compact
    end

    def filter_params
      filters.reduce({}) { |params, filter|
        value = filter.report_filter_value
        if value.present?
          params.merge(filter.name => value)
        else
          params
        end
      }
    end

    class << self
      attr_accessor :model

      def axis *args, &block
        axes << Axis.new(self, *args, &block)
        self
      end

      def axes
        @axes ||= []
      end
    end

    private

    def filters
      @filters
    end

    def axes
      self.class.axes
    end
  end
end
