require_relative "filter/cardinal"
require_relative "filter/rational"
require_relative "filter/enum"
require_relative "filter/bitmask"

module Makita
  module Filter
    def self.create type, *args, &block
      type = type.to_s.camelize
      klass = "Makita::Filter::#{type}"
      klass = klass.constantize
      klass.new *args, &block
    end
  end
end
