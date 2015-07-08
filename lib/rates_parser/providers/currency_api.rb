require 'net/http'
require 'json'

module RatesParser
  module Providers
    # currency-api.appspot.com
    class CurrencyApi < Provider
      register('currency-api.appspot.com')

      def initialize(config)
        @api_key = config['api_key']
      end

      def fetch_data(currencies)
        currencies.inject({}) do |hash, currency|
          uri       = data_uri(currency)
          response  = Net::HTTP.get_response(uri)
          json_body = JSON.parse(response.body)
          hash[currency] = json_body['rate'] || UNDEFINED_RATE_VALUE
          hash
        end
      end

      private

      def data_uri(currency)
        URI("http://currency-api.appspot.com/api/EUR/#{currency}.json?key=#{@api_key}")
      end
    end
  end
end
