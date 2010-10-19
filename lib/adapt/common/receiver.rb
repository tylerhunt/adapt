module Adapt
  module Common
    class Receiver < Base
      PAYMENT_TYPES = %w(GOODS SERVICE PERSONAL CASHADVANCE).freeze

      property :amount, :presence => true
      property :email
      property :invoice_id
      property :payment_type, :inclusion => { :in => PAYMENT_TYPES }
      property :phone, :type => Common::PhoneNumberType
      property :primary, :default => false, :inclusion => { :in => [true, false] }, :presence => true
    end
  end
end
