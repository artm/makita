require_relative "filter/cardinal"

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
