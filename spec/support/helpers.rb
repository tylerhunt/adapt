module RSpecHelpers
  module InstanceMethods
    def service(credentials={})
      credentials.reverse_merge!(
        :username => 'seller_1278210365_biz_api1.devoh.com',
        :password => '5RBB95ZTBDSR4MR2',
        :signature => 'A43UhUJ8Gsn-ptbpWEBRSvVxMZykA87EqndzoFCipFmz6cN2zycGoDjk',
        :ip => '127.0.0.1',
        :application_id => 'APP-80W284485P519543T',
      )

      Adapt::Service.new(credentials)
    end
  end
end

RSpec.configure do |config|
  config.include(RSpecHelpers::InstanceMethods)
end
