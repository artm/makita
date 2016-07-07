module Makita
  class Filter
    attr_reader :axis, :config

    def initialize axis, config
      @axis = axis
      @config = config
    end

    def apply relation
      relation.where(condition)
    end

    def condition
      { axis.name => config }
    end
  end
end
