require 'open-uri'
require 'nokogiri'

module RatesParser
  module Providers
    # ecb.europa.eu
    class ECBEuropa < Provider
      register('ecb.europa.eu')

      def fetch_data(currencies)
        xml_rates   = Nokogiri::XML(open(data_uri)).search('Cube/Cube/Cube')
        hash_rates  = Hash[xml_rates.map { |node| [node['currency'], node['rate']] }]
        currencies.inject({}) do |hash, currency|
          hash[currency] = hash_rates[currency] || UNDEFINED_RATE_VALUE
          hash
        end
      end

      private

      def data_uri
        'http://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml'
      end
    end
  end
end
