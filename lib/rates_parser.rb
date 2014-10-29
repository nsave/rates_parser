$LOAD_PATH.unshift(__dir__) unless $LOAD_PATH.include?(__dir__)
require 'rates_parser/providers_factory'

module RatesParser
  # Main class incapsulating all library functionality.
  # Delegates creating providers to 'ProviderFactory' and caches them
  class Parser
    def initialize
      # Loaded providers will be cached here
      @providers = {}
    end

    def load_provider(name)
      @providers[name] = ProvidersFactory.create(name)
    end

    def provider_loaded?(name)
      !@providers[name].nil?
    end

    # Delegates fetching rates of requested currencies to requested providers
    # @return [Hash] A hash associating providers names with recieved data
    def fetch_rates(providers_names, currencies)
      # Fetch rates only from requested providers
      result_array = providers_names.map do |name|
        # Load provider if it's not loaded yet
        provider = @providers[name] || load_provider(name)
        # Request rates
        rates = provider.get_rates(currencies)
        # Return a pair of provider name and the rates recieved from it
        [name, rates]
      end
      result_array.to_h
    end
  end
end
