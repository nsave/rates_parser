module RatesParser
  module Converter
    extend self
    # Converts rates from one source to another
    # @param [Hash] A hash associating currencies with their rates
    # @param [Float] A rate of a new source
    # @param [Float] A source rate of the passed rates
    def convert_rates(rates, new_source_rate, old_source_rate = 1)
      correct_factor = new_source_rate / old_source_rate
      Hash[rates.map { |key, val| [key, val / correct_factor] }]
    end
  end
end
