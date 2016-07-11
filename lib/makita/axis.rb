require_relative "filter"

module Makita
  class Axis
    attr_reader :space, :name, :type
    delegate :model, to: :space

    def initialize space, name, options = {}
      @space = space
      @name = name
      @type = options[:type] || pick_type
    end

    def make_filter params
      if params.include?(name)
        Filter.create(type, self, params[name])
      end
    end

    private

    def pick_type
      :cardinal
    end
  end
end
