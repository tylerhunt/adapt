require 'spec_helper'

describe Adapt::Methods::SetPaymentOptions do
  it_should_behave_like "a method"

  context "on success" do
    let(:request_attributes) do
      {
        :pay_key => 'AP-2DA87188GH806132S',

        :initiating_entity => {
          :institution_customer => {
            :institution_id => 'IN-GK2V-YSTX-Y5E4-Z9UR',
            :institution_customer_id => '23345',
            :first_name => 'John',
            :last_name => 'Smith',
            :display_name => 'Great Bank',
            :email => 'johnsmith@example.com',
            :country_code => 'US'
          }
        },

        :display_options => {
          :email_header_image_url => 'http://example.com/images/header.png',
          :email_marketing_image_url => 'http://example.com/images/logo.png'
        },

        :request_envelope => {
          :detail_level => 'ReturnAll',
          :error_language => 'en_US'
        }
      }
    end

    let(:response_fixture) { 'set_payment_options_success' }

    subject { response }

    context "response envelope" do
      subject { response.response_envelope }

      its(:timestamp) { should == '2010-08-05T20:31:40.291-07:00' }
      its(:ack) { should == 'Success' }
      its(:correlation_id) { should == 'cca2fd6c44bd7' }
      its(:build) { should == '1437064' }
    end

    context "error" do
      it("is nil") { response.error.should be_nil }
    end
  end

  context "on failure" do
    let(:request_attributes) {
      {
        :pay_key => 'AP-2DA87188GH806132S',

        :initiating_entity => {
          :institution_customer => {
            :institution_id => 'IN-GK2V-YSTX-Y5E4-Z9UR',
            :institution_customer_id => '23345',
            :first_name => 'John',
            :last_name => 'Smith',
            :display_name => 'Great Bank',
            :email => 'johnsmith@example.com',
            :country_code => 'US'
          }
        },

        :display_options => {
          :email_header_image_url => 'http://example.com/images/header.png',
          :email_marketing_image_url => 'http://example.com/images/logo.png'
        },

        :request_envelope => {
          :detail_level => 'ReturnAll',
          :error_language => 'en_US'
        }
      }
    }

    let(:response_fixture) { 'set_payment_options_failure' }

    subject { response }

    context "response envelope" do
      subject { response.response_envelope }

      its(:timestamp) { should == '2010-10-18T19:35:24.582-07:00' }
      its(:ack) { should == 'Failure' }
      its(:correlation_id) { should == 'c2e331508294d' }
      its(:build) { should == '1565353' }
    end

    context "error" do
      subject { response.error.first }

      its(:error_id) { should == '580022' }
      its(:domain) { should == 'PLATFORM' }
      its(:severity) { should == 'Error' }
      its(:category) { should == 'Application' }
      its(:message) { should == 'payKey AP-2DA87188GH806132S is expired' }
    end
  end
end
