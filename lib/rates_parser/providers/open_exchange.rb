require 'net/http'
require 'json'
require 'rates_parser/converter'

module RatesParser
  module Providers
    # openexchangerates.org
    class OpenExchange < Provider
      register('openexchangerates.org')

      def initialize(config)
        @api_key = config['api_key']
      end

      def fetch_data(currencies)
        response    = Net::HTTP.get_response(data_uri)
        json_rates  = JSON.parse(response.body)['rates']

        euro_rate   = json_rates['EUR']
        json_rates.select! { |key| currencies.include?(key) }

        RatesParser::Converter.convert_rates(json_rates, euro_rate)
      end

      private

      def data_uri
        URI("http://openexchangerates.org/latest.json?app_id=#{@api_key}")
      end
    end
  end
end
