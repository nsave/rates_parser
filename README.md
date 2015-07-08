Rates parser lib
=================

A try to implement extensible and unified way to get currencies rates from different providers.

Example of use:
---------------

```ruby
require 'rates_parser'

parser = RatesParser::Parser.new
currencies = %w(AUD USD NOK)
providers = %w(
  openexchangerates.org
  currency-api.appspot.com
  ecb.europa.eu
)
parser.fetch_rates(providers, currencies)

# =>
#  {
#    "openexchangerates.org" => {
#      "AUD" => "1.4343",
#      "NOK" => "8.4244",
#      "USD" => "1.2730"
#    },
#    "currency-api.appspot.com" => {
#      "AUD" => "1.4432",
#      "USD" => "1.2706",
#      "NOK" => "n/a"
#    },
#    "ecb.europa.eu" => {
#      "AUD" => 1.4370,
#      "USD" => 1.2748,
#      "NOK" => 8.4415
#    }
#  }
```

Currently implemented providers:
--------------------------------
1. openexchangerates.org
2. currency-api.appspot.com
3. ecb.europa.eu

*Some implementations need config. See 'rates_parser_config.yaml.example'*
