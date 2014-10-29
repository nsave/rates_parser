require 'rates_parser/config'

module RatesParser
  # Error class to raise when asked provider is not registered
  class ProviderNotRegistered < NameError; end

  # A factory wich produces different subclasses of 'Provider' class
  # For the factory be able instantiate a custom provider it must be registered
  #  using 'register' static method,
  #  otherwise a 'ProviderNotRegistered' wil be raised
  class ProvidersFactory
    @@registered_providers = {}

    # Creates specified provider
    # @raise [ProviderNotRegistered] If specified provider is not registered
    # @return [Provider] Requested provider
    def self.create(name)
      provider = @@registered_providers[name]
      config = providers_config[name]

      if provider
        provider.new(config)
      else
        fail ProviderNotRegistered, "Provider #{name} is not registered"
      end
    end

    # Registers a provider (a pair of provider name and its class)
    # @param [String] name Name of the provider
    # @param [Provider] clazz Class of a subclass of 'Provider'
    def self.register(name, clazz)
      @@registered_providers[name] = clazz
    end

    private

    def self.providers_config
      Config.data["rates_providers"]
    end
  end
end

# First require base provider
require 'rates_parser/providers/provider'
# Then require all implementations
# (Require without extension)
Dir[File.join(__dir__, 'providers', '*.rb')].each { |file| require file[0..-4] }
