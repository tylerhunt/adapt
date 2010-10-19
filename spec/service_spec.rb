require 'spec_helper'

describe Adapt::Service do
  let(:credentials) do
    {
      :username => 'seller_1278210365_biz_api1.devoh.com',
      :password => '5RBB95ZTBDSR4MR2',
      :signature => 'A43UhUJ8Gsn-ptbpWEBRSvVxMZykA87EqndzoFCipFmz6cN2zycGoDjk',
      :ip => '127.0.0.1',
      :application_id => 'APP-80W284485P519543T',
    }
  end

  let(:headers) do
    {
      'X-PAYPAL-SECURITY-USERID' => 'seller_1278210365_biz_api1.devoh.com',
      'X-PAYPAL-SECURITY-PASSWORD' => '5RBB95ZTBDSR4MR2',
      'X-PAYPAL-SECURITY-SIGNATURE' => 'A43UhUJ8Gsn-ptbpWEBRSvVxMZykA87EqndzoFCipFmz6cN2zycGoDjk',
      'X-PAYPAL-DEVICE-IPADDRESS' => '127.0.0.1',
      'X-PAYPAL-REQUEST-DATA-FORMAT' => 'JSON',
      'X-PAYPAL-RESPONSE-DATA-FORMAT' => 'JSON',
      'X-PAYPAL-APPLICATION-ID' => 'APP-80W284485P519543T'
    }
  end

  let(:service) { Adapt::Service.new(credentials) }

  it "can be initialized with credentials" do
    Adapt::Service.new(credentials)
  end

  context "#headers" do
    it "returns a hash with the default headers" do
      service.headers.should == headers
    end

    it "includes the subject if one is set in the credentials" do
      service = Adapt::Service.new(
        credentials.merge(:subject => 'api@example.com')
      )

      service.headers.should == headers.merge(
        'X-PAYPAL-SUBJECT' => 'api@example.com'
      )
    end

    it "includes the device ID if one is set in the credentials" do
      service = Adapt::Service.new(
        credentials.merge(:device => '35-209900-176148-1')
      )

      service.headers.should == headers.merge(
        'X-PAYPAL-DEVICE-ID' => '35-209900-176148-1'
      )
    end

    it "includes the service version if one is set in the credentials" do
      service = Adapt::Service.new(credentials.merge(:version => '56.0'))

      service.headers.should == headers.merge(
        'X-PAYPAL-SERVICE-VERSION' => '56.0'
      )
    end
  end

  context "#endpoint" do
    context "in the default environment" do
      it "returns a sandbox endpoint URI for the specified method" do
        service.environment = nil
        service.endpoint('Pay').should == URI.parse('https://svcs.sandbox.paypal.com/AdaptivePayments/Pay')
      end
    end

    context "in the sandbox environment" do
      it "returns a sandbox endpoint URI for the specified method" do
        service.environment = :sandbox
        service.endpoint('Pay').should == URI.parse('https://svcs.sandbox.paypal.com/AdaptivePayments/Pay')
      end
    end

    context "in the beta environment" do
      it "returns a beta endpoint URI for the specified method" do
        service.environment = :beta
        service.endpoint('Pay').should == URI.parse('https://svcs.beta-sandbox.paypal.com/AdaptivePayments/Pay')
      end
    end

    context "in the live environment" do
      it "returns a live endpoint URI for the specified method" do
        service.environment = :live
        service.endpoint('Pay').should == URI.parse('https://svcs.paypal.com/AdaptivePayments/Pay')
      end
    end

    it "raises an error if no method is specified" do
      expect { service.endpoint }.to raise_error(ArgumentError)
    end

    it "raises an error if an invalid method is specified" do
      expect { service.endpoint('Barter') }.to raise_error(ArgumentError, /invalid method/i)
    end
  end

  context "#request" do
    let(:session) { Patron::Session.new }
    let(:request) { Adapt::Methods::ConvertCurrency::Request.new }

    before(:each) do
      session.stub!(:post)
      Patron::Session.stub!(:new).and_return(session)
    end

    after(:each) do
      service.request('ConvertCurrency', request)
    end

    it "sets the request timeout to 10 seconds" do
      session.should_receive(:timeout=).with(10)
    end

    it "disables SSL certificate verification" do
      session.should_receive(:insecure=).with(true)
    end

    it "uses the specified method to build the endpoint URI for the request" do
      session.should_receive(:base_url=).with('https://svcs.sandbox.paypal.com:443')
    end

    it "issues a POST request" do
      session.should_receive(:post)
    end

    it "uses the path from the endpoint URI" do
      path = '/AdaptivePayments/ConvertCurrency'
      session.should_receive(:post).with(path, anything, anything)
    end

    it "uses the JSON form of the request object as the request body" do
      json = '{"format":"json"}'
      request.stub!(:to_json).and_return(json)
      session.should_receive(:post).with(anything, json, anything)
    end

    it "uses the headers" do
      session.should_receive(:post).with(anything, anything, headers)
    end
  end
end
