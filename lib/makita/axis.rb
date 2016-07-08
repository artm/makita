require_relative "filter"

module Makita
  class Axis
    attr_reader :name

    def initialize name, options = {}
      @name = name
      @type = options[:type] || pick_type
    end

    def make_filter params
      if params.include?(name)
        Filter.new(self, params[name])
      end
    end

    private

    def pick_type
      :cardinal
    end
  end
end
