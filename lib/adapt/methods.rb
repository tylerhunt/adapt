module Adapt
  module Methods
    autoload :CancelPreapproval, 'adapt/methods/cancel_preapproval'
    autoload :ConvertCurrency, 'adapt/methods/convert_currency'
    autoload :ExecutePayment, 'adapt/methods/execute_payment'
    autoload :GetPaymentOptions, 'adapt/methods/get_payment_options'
    autoload :Pay, 'adapt/methods/pay'
    autoload :PaymentDetails, 'adapt/methods/payment_details'
    autoload :Preapproval, 'adapt/methods/preapproval'
    autoload :PreapprovalDetails, 'adapt/methods/preapproval_details'
    autoload :Refund, 'adapt/methods/refund'
    autoload :SetPaymentOptions, 'adapt/methods/set_payment_options'
  end
end
