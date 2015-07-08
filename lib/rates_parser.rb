$LOAD_PATH.unshift(__dir__) unless $LOAD_PATH.include?(__dir__)
require 'rates_parser/config'
require 'rates_parser/providers_factory'

module RatesParser
  class Parser
    def initialize
      @providers = {}
    end

    def get_provider(name)
      @providers[name] || load_provider(name)
    end

    def fetch_rates(providers_names, currencies)
      providers_names.inject({}) do |hash, name|
        provider    = get_provider(name)
        rates       = provider.get_rates(currencies)
        hash[name]  = rates
        hash
      end
    end

    private

    def load_provider(name)
      @providers[name] = ProvidersFactory.create(name)
    end
  end
end
