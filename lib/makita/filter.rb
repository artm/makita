module Makita
  class Filter
    attr_reader :axis, :config

    def initialize axis, config
      @axis = axis
      config = { eq: config } unless Hash === config
      @config = config
    end

    def apply relation
      relation.where(*conditions)
    end

    def conditions
      @config.map{|op,value|
        case op
        when :eq
          { axis.name => value }
        when :ge
          ["#{axis.name} >= ?", value]
        end
      }
    end
  end
end
