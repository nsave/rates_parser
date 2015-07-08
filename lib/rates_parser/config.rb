require 'yaml'

module RatesParser
  class Config
    CONFIG_FILE_PATH = 'rates_parser_config.yaml'

    def self.data
      @data ||= YAML.load_file(CONFIG_FILE_PATH)
    end
  end
end
