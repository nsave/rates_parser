require 'open-uri'
require 'nokogiri'

module RatesParser
  module Providers
    # 'Provider' implementation for 'ecb.europa.eu' API
    # This implementation doesn't require any config
    class ECBEuropa < Provider
      # Register this provider in 'ProvidersFactory' with specified name
      register('ecb.europa.eu')

      def fetch_data(currencies)
        # Request data
        xml = Nokogiri::XML(open(data_uri))

        # Parse rates
        xml_rates = xml.search('Cube/Cube/Cube')
        # Convert rates to hash
        hash_rates = Hash[xml_rates.map { |node| [node['currency'], node['rate']] }]
        # Filter out not requested rates
        Hash[ currencies.map { |cur| [cur, hash_rates[cur] || UNDEFINED_RATE_VALUE] }]
      end

      private
      
      def data_uri
        'http://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml'
      end
    end
  end
end
