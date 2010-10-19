require 'spec_helper'

describe Adapt::Methods::Pay do
  it_should_behave_like "a method"

  context "on success" do
    let(:request_attributes) do
      {
        :action_type => 'PAY',
        :cancel_url => 'http://example.com/cancel',
        :currency_code => 'USD',
        :return_url => 'http://example.com/return',
        :sender_email => 'buyer_1285818165_per@devoh.com',

        :receiver_list => {
          :receiver => [
            {
              :amount => '10.00',
              :email => 'seller_1278210365_biz@devoh.com'
            }
          ]
        },

        :request_envelope => {
          :detail_level => 'ReturnAll',
          :error_language => 'en_US'
        }
      }
    end

    let(:response_fixture) { 'pay_success' }

    subject { response }

    context "response envelope" do
      subject { response.response_envelope }

      its(:timestamp) { should == '2010-09-29T20:43:42.333-07:00' }
      its(:ack) { should == 'Success' }
      its(:correlation_id) { should == 'c3d8817d023d0' }
      its(:build) { should == '1437064' }
    end

    its(:pay_key) { should == 'AP-2DA87188GH806132S' }
    its(:payment_exec_status) { should == 'CREATED' }

    context "error" do
      it("is nil") { response.error.should be_nil }
    end
  end

  context "on failure" do
    let(:request_attributes) {
      {
        :action_type => 'PAY',
        :cancel_url => 'http://example.com/cancel',
        :currency_code => 'USD',
        :return_url => 'http://example.com/return',
        :sender_email => 'buyer_1285818165_per@devoh.com',

        :receiver_list => {
          :receiver => [
            {
              :amount => '-10.00',
              :email => 'mary@example.com'
            }
          ]
        },

        :request_envelope => {
          :detail_level => 'ReturnAll',
          :error_language => 'en_US'
        }
      }
    }

    let(:response_fixture) { 'pay_failure' }

    subject { response }

    context "response envelope" do
      subject { response.response_envelope }

      its(:timestamp) { should == '2010-10-18T19:07:59.903-07:00' }
      its(:ack) { should == 'Failure' }
      its(:correlation_id) { should == '248d741ff0f1f' }
      its(:build) { should == '1565353' }
    end

    it('pay_key') { response.pay_key.should be_nil }
    it('payment_exec_status') { response.payment_exec_status.should be_nil }

    context "pay error list" do
      context "error" do
        subject { response.error.first }

        its(:error_id) { should == '580022' }
        its(:domain) { should == 'PLATFORM' }
        its(:severity) { should == 'Error' }
        its(:category) { should == 'Application' }
        its(:message) { should == 'Invalid request parameter: amount must be greater than zero' }
      end

      context "receiver" do
        subject { response.pay_error_list.first.receiver }
      end
    end
  end
end
