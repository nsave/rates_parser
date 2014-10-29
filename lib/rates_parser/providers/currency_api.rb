require 'net/http'
require 'json'

module RatesParser
  module Providers
    # 'Provider' implementation for 'currency-api.appspot.com' API
    # An api key must be provided via config.
    #  See 'rates_parser_config.yaml.example'.
    class CurrencyApi < Provider
      # Register this provider in 'ProvidersFactory' with specified name
      register('currency-api.appspot.com')

      def initialize config
        @api_key = config['api_key']
      end

      def fetch_data(currencies)
        rates = {}

        # Fetch each currency by one
        currencies.each do |currency|
          # Generate currency specific uri
          uri = data_uri(currency)
          # Request data
          response = Net::HTTP.get_response(uri)
          # Parse rate
          json_body = JSON.parse(response.body)
          # Add value to all rates
          rates[currency] = json_body['rate'] || UNDEFINED_RATE_VALUE
        end

        rates
      end

      private
      
      def data_uri(currency)
        URI("http://currency-api.appspot.com/api/EUR/#{currency}.json?key=#{@api_key}")
      end
    end
  end
end
