require 'net/http'
require 'json'
require 'rates_parser/converter'

module RatesParser
  module Providers
    # 'Provider' implementation for 'openexchangerates.org' API
    # An api key must be provided via config.
    #  See 'rates_parser_config.yaml.example'.
    # Unfortunately openexchangerates.org provides rates based on 'USD'
    #  but this implementation converts recieved rates to 'EUR'.
    class OpenExchange < Provider
      # Register this provider in 'ProvidersFactory' with specified name
      register('openexchangerates.org')

      def initialize(config)
        @api_key = config['api_key']
      end

      def fetch_data(currencies)
        # Request data from uri
        response = Net::HTTP.get_response(data_uri)
        # Parse rates
        rates = JSON.parse(response.body)['rates']

        # Find euro rate
        euro_rate = rates['EUR']

        # Filter out not requested currencies
        rates.select! { |key, _val| currencies.include? key }

        # Convert rates to euro source and return
        RatesParser::Converter.convert_rates(rates, euro_rate)
      end

      private
      
      def data_uri
        URI("http://openexchangerates.org/latest.json?app_id=#{@api_key}")
      end
    end
  end
end
