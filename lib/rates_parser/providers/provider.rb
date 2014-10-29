module RatesParser
  module Providers
    # Base class for all providers
    class Provider
      # This value will be used for each rate that cannot be set for any reason
      UNDEFINED_RATE_VALUE = 'n/a'

      # Provide base constructor with optional config
      #  as not each provider needs it
      def initialize(_config = nil)
      end

      # Gets rates from the provider
      # @param [Array] currencies An array of requested currencies
      # @return [Hash] A result from the provider work
      #  if a error occures the hash will be filled with stubbed rates
      #  and the error will be associated with 'error' key
      def get_rates(currencies)
        begin
          data = fetch_data(currencies)
          normalize_data(data)
        rescue StandardError => e
          # Stub rates with undefined values
          result = stub_result(currencies)
          # Set the error
          result['error'] = e
          result
        end
      end

      # Default implementation returning downcased provider class name
      def name
        self.class.downcase
      end

      protected

      # This method must be overrided in a subclass
      # Should implement specific for each provider fetching rates process
      # @param [Array] An array of requested currencies
      # @return [Hash] An association of currency name and its rate
      def fetch_data(_currencies)
        fail NotImplementedError
      end

      # Registers a subclass of 'Provider' associated with passed provider name.
      #  If no provider name passed, a result of the 'name' method will be used
      def self.register(provider_name = nil)
        provider_name ||= name
        ProvidersFactory.register(provider_name, self)
      end

      private
      
      def stub_result(currencies)
        Hash[currencies.map { |name| [name, UNDEFINED_RATE_VALUE] }]
      end

      def normalize_data(data)
        data.each_with_object({}) do |(k, v), h|
          h[k] = normalize_rate(v)
        end
      end

      def normalize_rate(rate)
        return rate.to_s[0..5]
      end
    end
  end
end
