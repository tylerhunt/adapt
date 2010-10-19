module Adapt
  module Methods
    # Sets up pre-approvals, which is an approval to make future payments on the
    # sender's behalf
    class Preapproval < Base
      CURRENCY_CODES = %w(AUD BRL CAD CZK DKK EUR HKD HUF ILS JPY MYR MXN NOK NZD PHP PLN GBP SGD SEK CHF TWD THB USD).freeze
      DAYS_OF_WEEK = %w(NO_DAY_SPECIFIED SUNDAY MONDAY TUESDAY WEDNESDAY THURSDAR FRIDAY SATURDAY).freeze
      PAYMENT_PERIODS = %w(NO_PERIOD_SPECIFIED DAILY WEEKLY BIWEEKLY SEMIMONTHLY MONTHLY ANNUALLY).freeze
      PIN_TYPES = %w(NOT_REQUIRED REQUIRED).freeze

      class Request < Base
        property :cancel_url, :presence => true
        property :client_details, :type => Common::ClientDetails
        property :currency_code, :presence => true, :inclusion => { :in => CURRENCY_CODES }
        property :date_of_month, :numericality => { :greater_than_or_equal_to => 0, :less_than_or_equal_to => 31 }
        property :day_of_week, :inclusion => { :in => DAYS_OF_WEEK }
        property :ending_date, :presence => true
        property :ipn_notificaiton_url
        property :max_amount_per_payment, :numericality => true
        property :max_number_of_payments, :numericality => { :integer_only => true }
        property :max_number_of_payments_per_period, :numericality => { :integer_only => true }
        property :max_total_amount_of_all_payments, :presence => true, :numericality => true
        property :memo
        property :payment_period, :inclusion => { :in => PAYMENT_PERIODS }
        property :pin_type, :inclusion => { :in => PIN_TYPES }
        property :request_envelope, :type => Common::RequestEnvelope, :presence => true
        property :return_url, :presence => true
        property :sender_email
        property :starting_date, :presence => true
      end

      class Response < Base
        property :preapproval_key
        property :response_envelope, :type => Common::ResponseEnvelope
        property :error, :type => [Common::ErrorData]
      end
    end
  end
end
