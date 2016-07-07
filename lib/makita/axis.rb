require_relative "filter"

module Makita
  class Axis
    attr_reader :name

    def initialize name
      @name = name
    end

    def make_filter params
      if params.include?(name)
        Filter.new(self, params)
      end
    end
  end
end
