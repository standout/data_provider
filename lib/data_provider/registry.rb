require 'ostruct'

module DataProvider
  class Registry
    attr_reader :providers

    def initialize
      @providers = OpenStruct.new
    end

    def add_provider(name, klass, options = {})
      @providers[name] = Provider.new(name, klass.new(options))
    end
  end
end
