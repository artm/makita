module Makita
  class Filter
    attr_reader :axis, :params

    def initialize axis, params
      @axis = axis
      @params = params
    end

    def apply relation
      relation.where(condition)
    end

    def condition
      { axis.name => params[axis.name] }
    end
  end
end
