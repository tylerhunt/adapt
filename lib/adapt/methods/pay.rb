module Adapt
  module Methods
    # Transfers funds from a sender's PayPal account to one or more receivers’
    # PayPal accounts (up to 6 receivers)
    #
    # Redirect the user to the following URL for approval:
    # "https://www.paypal.com/webscr?cmd=_ap-payment&paykey=#{response.pay_key}"
    class Pay
      ACTION_TYPES = %w(PAY CREATE PAY_PRIMARY).freeze
      CURRENCY_CODES = %w(AUD BRL CAD CZK DKK EUR HKD HUF ILS JPY MYR MXN NOK NZD PHP PLN GBP SGD SEK CHF TWD THB USD).freeze
      FEES_PAYERS = %w(SENDER PRIMARYRECEIVER EACHRECEIVER SECONDARYONLY).freeze
      PAYMENT_PERIODS = %w(NO_PERIOD_SPECIFIED DAILY WEEKLY BIWEEKLY SEMIMONTHLY MONTHLY ANNUALLY).freeze
      PIN_TYPES = %w(NOT_REQUIRED REQUIRED).freeze
      WEEK_DAYS = %w(NO_DAY_SPECIFIED SUNDAY MONDAY TUESDAY WEDNESDAY THURSDAY FRIDAY SATURDAY).freeze
      FUNDING_TYPES = %w(ECHECK BALANCE CREDITCARD)

      class Request < Base
        property :action_type, :inclusion => { :in => ACTION_TYPES }, :presence => true
        property :cancel_url, :presence => true
        property :client_details
        property :currency_code, :inclusion => { :in => CURRENCY_CODES }
        property :date_of_month, :numericality => { :greater_than_or_equal_to => 0, :less_than_or_equal_to => 31 }
        property :day_of_week, :inclusion => { :in => WEEK_DAYS }
        property :ending_date
        property :ipn_notification_url
        property :max_amount_per_payment
        property :max_number_of_payments
        property :max_number_of_payments_per_period
        property :max_total_amount_of_all_payments
        property :payment_period, :inclusion => { :in => PAYMENT_PERIODS }
        property :pin_type, :inclusion => { :in => PIN_TYPES }
        property :starting_date, :presence => true
        property :fees_payer, :inclusion => { :in => FEES_PAYERS }
        property :memo, :length => { :maximum => 1000 }
        property :pin
        property :preapproval_key
        property :receiver_list, :type => Common::ReceiverList
        property :request_envelope, :type => Common::RequestEnvelope, :presence => true
        property :return_url, :presence => true
        property :reverse_all_parallel_payments_on_error, :inclusion => { :in => [true, false] }
        property :sender_email
        property :tracking_id

        property :funding_constraint, :collection => true do
          property :allowed_funding_type do
            property :funding_type_info do
              property :funding_type, :presence => true, :inclusion => { :in => FUNDING_TYPES }
            end
          end
        end
      end

      class Response < Base
        property :error, :type => Common::ErrorData, :collection => true
        property :pay_key
        property :payment_exec_status
        property :response_envelope, :type => Common::ResponseEnvelope

        property :pay_error_list do
          property :pay_error, :collection => true do
            property :error, :type => Common::ErrorData
            property :receiver, :type => Common::Receiver
          end
        end
      end
    end
  end
end
