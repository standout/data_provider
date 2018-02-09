require 'data_provider/configuration'
require 'data_provider/provider'
require 'data_provider/registry'
require 'data_provider/version'

module DataProvider
  @configuration = Configuration.new
  @registry = Registry.new

  def self.config
    @configuration
  end

  def self.configure
    yield @configuration if block_given?
  end

  def self.register(name, klass, options = {}, &block)
    @registry.add_provider(name, klass, options, &block)
  end

  def self.providers
    @registry.providers
  end
end
