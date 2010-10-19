require 'active_support/core_ext/string/inflections'

module Adapt
  class Service
    METHODS = %w[
      CancelPreapproval
      ConvertCurrency
      ExecutePayment
      GetPaymentOptions
      Pay
      PaymentDetails
      Preapproval
      PreapprovalDetails
      Refund
      SetPaymentOptions
    ].freeze

    attr_reader :credentials
    attr_accessor :environment

    def initialize(credentials)
      @credentials = credentials
      @environment = :sandbox
    end

    def defaults
      {
        :request_format => 'JSON',
        :response_format => 'JSON'
      }
    end

    def headers
      {
        'X-PAYPAL-SECURITY-USERID' => credentials[:username],
        'X-PAYPAL-SECURITY-PASSWORD' => credentials[:password],
        'X-PAYPAL-SECURITY-SIGNATURE' => credentials[:signature],
        'X-PAYPAL-DEVICE-IPADDRESS' => credentials[:ip],
        'X-PAYPAL-REQUEST-DATA-FORMAT' => defaults[:request_format],
        'X-PAYPAL-RESPONSE-DATA-FORMAT' => defaults[:response_format],
        'X-PAYPAL-APPLICATION-ID' => credentials[:application_id]
      }.tap do |parameters|
        if credentials[:subject]
          parameters['X-PAYPAL-SUBJECT'] = credentials[:subject]
        end

        if credentials[:device]
          parameters['X-PAYPAL-DEVICE-ID'] = credentials[:device]
        end

        if credentials[:version]
          parameters['X-PAYPAL-SERVICE-VERSION'] = credentials[:version]
        end
      end
    end

    def endpoint(method)
      if METHODS.include?(method)
        root = case environment
          when :live then LIVE
          when :beta then BETA
          else SANDBOX
        end

        URI.parse([root, method].join('/'))
      else
        raise ArgumentError.new("Invalid method: #{method}")
      end
    end

    def request(method, request={})
      uri = endpoint(method)

      session = Patron::Session.new.tap do |session|
        session.timeout = 10
        session.insecure = true
        session.base_url = "#{uri.scheme}://#{uri.host}:#{uri.port}"
      end

      session.post(uri.path, request.to_json, headers)
    end
  end
end
