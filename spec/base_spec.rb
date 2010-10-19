require 'spec_helper'

describe Adapt::Base do
  let(:instance) { Example::Common.new }

  before(:each) do
    module Example
      class Common < Adapt::Base
      end
    end
  end

  after(:each) do
    Example.send(:remove_const, :Common)
  end

  context ".property" do
    before(:each) do
      Example::Common.class_eval do
        property :error_language
      end
    end

    it "allows a property to be set" do
      expect {
        instance.error_language = 'en_US'
      }.to change { instance.error_language }.from(nil).to('en_US')
    end

    context "defaults" do
      before(:each) do
        Example::Common.class_eval do
          property :error_language, :default => 'en_US'
        end
      end

      it "accepts a default value" do
        instance.error_language.should == 'en_US'
      end

      it "can override the default value" do
        expect {
          instance.error_language = 'en_GB'
        }.to change { instance.error_language }.from('en_US').to('en_GB')
      end
    end

    context "types" do
      before(:each) do
        Example::Common.class_eval do
          class Envelope < Adapt::Base
            property :ack
            property :build
          end

          property :response_envelope, :type => Envelope
        end
      end

      it "accepts nested attributes" do
        json = '{"responseEnvelope":{"ack":"Failure","build":"1383772"}}'
        instance.from_json(json)
        instance.response_envelope.ack.should == 'Failure'
        instance.response_envelope.build.should == '1383772'
      end
    end

    context "collections" do
      before(:each) do
        Example::Common.class_eval do
          class Response < Adapt::Base
            property :code
            property :message
            property :parameter
          end

          property :errors, :type => Response, :collection => true
        end
      end

      it "accepts collections of nested attributes" do
        json = '{"errors":[{"code":"560022","message":"Error","parameter":["X-PAYPAL-APPLICATION-ID"]}]}'
        instance.from_json(json)
        instance.errors.first.code.should == '560022'
        instance.errors.first.message.should == 'Error'
        instance.errors.first.parameter.should == ['X-PAYPAL-APPLICATION-ID']
      end
    end


    context "validations" do
      before(:each) do
        Example::Common.class_eval do
          property :error_language, :presence => true
        end
      end

      it "allows validations to be set" do
        expect {
          instance.error_language = 'en_US'
        }.to change { instance.valid? }.from(false).to(true)
      end
    end
  end

  context "#attributes" do
    before(:each) do
      Example::Common.class_eval do
        property :detail_level, :default => 'ReturnAll'
        property :error_language, :default => 'en_US'
      end
    end

    it "returns a hash of attribute values" do
      instance.attributes.should == {
        'detailLevel' => 'ReturnAll',
        'errorLanguage' => 'en_US'
      }
    end

    it "doesn't include nil values in the attributes hash" do
      instance.detail_level = nil
      instance.attributes.should == { 'errorLanguage' => 'en_US' }
    end

    it "converts all values to strings" do
      instance.detail_level = 4
      instance.attributes.should == {
        'detailLevel' => 4,
        'errorLanguage' => 'en_US'
      }
    end
  end

  context "#attributes=" do
    before(:each) do
      Example::Common.class_eval do
        property :detail_level
        property :error_language
      end
    end

    it "sets the attributes using the provided hash" do
      instance.attributes = {
        'detailLevel' => 'ReturnAll',
        'errorLanguage' => 'en_US'
      }

      instance.detail_level.should == 'ReturnAll'
      instance.error_language.should == 'en_US'
    end
  end

  context "#to_json" do
    before(:each) do
      Example::Common.class_eval do
        property :detail_level, :default => 'ReturnAll'
        property :error_language, :default => 'en_US'
      end
    end

    it "produces a JSON serialization of the attribute values" do
      ActiveSupport::JSON.decode(instance.to_json).should == ActiveSupport::JSON.decode('{"detailLevel":"ReturnAll","errorLanguage":"en_US"}')
    end

    it "doesn't include nil values in the JSON output" do
      instance.detail_level = nil
      ActiveSupport::JSON.decode(instance.to_json).should == ActiveSupport::JSON.decode('{"errorLanguage":"en_US"}')
    end

    it "converts all values to strings" do
      instance.detail_level = 4
      ActiveSupport::JSON.decode(instance.to_json).should == ActiveSupport::JSON.decode('{"detailLevel":4,"errorLanguage":"en_US"}')
    end
  end

  context "#from_json" do
    before(:each) do
      Example::Common.class_eval do
        property :detail_level
        property :error_language
      end
    end

    it "sets the attributes using the provided JSON" do
      instance.from_json('{"detailLevel":"ReturnAll","errorLanguage":"en_US"}')
      instance.detail_level.should == 'ReturnAll'
      instance.error_language.should == 'en_US'
    end
  end
end
