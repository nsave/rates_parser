Rates parser lib
=================

A try to implement extensible and unified way to get currencies rates from different providers.

Example of use:
---------------

   parser = RatesParser::Parser.new
   currencies = %w(AUD USD NOK)
   providers = %w(
     openexchangerates.org
     currency-api.appspot.com
     ecb.europa.eu
   )


Currently implemented providers:
--------------------------------
1. openexchangerates.org
2. currency-api.appspot.com
3. ecb.europa.eu

**Some implementations need config. See 'rates_parser_config.yaml.example'**
