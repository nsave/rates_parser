module RatesParser
  module Providers
    class Provider
      UNDEFINED_RATE_VALUE = 'n/a'

      def initialize(_config = nil)
      end

      # @param [Array] currencies An array of requested currencies
      # @return [Hash] A result from the provider work
      def get_rates(currencies)
        begin
          data = fetch_data(currencies)
          normalize_data(data)
        rescue StandardError => e
          build_failed_result(currencies, e)
        end
      end

      def name
        self.class.downcase
      end

      protected

      # @param [Array] An array of requested currencies
      # @return [Hash] An association of currency name and its rate
      def fetch_data(_currencies)
        fail NotImplementedError
      end

      def self.register(provider_name = nil)
        provider_name ||= name
        ProvidersFactory.register(provider_name, self)
      end

      private

      def build_failed_result(currencies, error)
        result = Hash[currencies.map { |name| [name, UNDEFINED_RATE_VALUE] }]
        result['error'] = error
      end

      def normalize_data(data)
        data.inject({}) do |hash, (currency, rate)|
          hash[currency] = normalize_rate(rate)
          hash
        end
      end

      def normalize_rate(rate)
        return rate.to_f.round(5) rescue UNDEFINED_RATE_VALUE
      end
    end
  end
end
