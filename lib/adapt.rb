require 'active_model'
require 'bigdecimal'
require 'patron'

module Adapt
  VERSION = '56.0'.freeze

  LIVE = 'https://svcs.paypal.com/AdaptivePayments'.freeze
  SANDBOX = 'https://svcs.sandbox.paypal.com/AdaptivePayments'.freeze
  BETA = 'https://svcs.beta-sandbox.paypal.com/AdaptivePayments'.freeze

  autoload :Base, 'adapt/base'
  autoload :Common, 'adapt/common'
  autoload :Methods, 'adapt/methods'
  autoload :Service, 'adapt/service'
end
