module RatesParser
  class ProviderNotRegistered < NameError; end

  class ProvidersFactory
    @@registered_providers = {}

    # Creates specified provider
    # @raise [ProviderNotRegistered] If specified provider is not registered
    # @return [Provider] Requested provider
    def self.create(name)
      provider_class  = @@registered_providers[name]
      config          = providers_config[name]

      if provider_class
        provider_class.new(config)
      else
        raise ProviderNotRegistered, "Provider #{name} is not registered"
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

require 'rates_parser/providers/provider'
Dir[File.join(__dir__, 'providers', '*.rb')].each { |path| require path }
