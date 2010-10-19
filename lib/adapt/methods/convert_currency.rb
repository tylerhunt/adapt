module Adapt
  module Methods
    # Obtains Foreign Exchange currency conversion rates for a list of amounts
    class ConvertCurrency < Base
      CURRENCY_CODES = %w(AUD BRL CAD CZK DKK EUR HKD HUF ILS JPY MYR MXN NOK NZD PHP PLN GBP SGD SEK CHF TWD THB USD).freeze

      class CurrencyType < Base
        property :amount, :presence => true
        property :code, :presence => true, :inclusion => { :in => CURRENCY_CODES }
      end

      class Request < Base
        property :base_amount_list, :collection => true do
          property :currency, :type => CurrencyType
        end

        property :convert_to_currency_list, :collection => true do
          property :currency_code, :presence => true, :inclusion => { :in => CURRENCY_CODES }
        end

        property :request_envelope, :type => Common::RequestEnvelope
      end

      class Response < Base
        property :estimated_amount_table do
          property :currency_conversion_list, :collection => true do
            property :base_amount, :type => CurrencyType

            property :currency_list do
              property :currency, :type => [CurrencyType]
            end
          end
        end

        property :response_envelope, :type => Common::ResponseEnvelope
        property :error, :type => [Common::ErrorData]
      end
    end
  end
end
