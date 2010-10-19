require 'spec_helper'

describe Adapt::Methods::Preapproval do
  it_should_behave_like "a method"

  context "on success" do
    let(:request_attributes) do
      {
        :cancel_url => 'http://example.com/cancel',
        :currency_code => 'USD',
        :date_of_month => '1',
        :day_of_week => 'NO_DAY_SPECIFIED',
        :ending_date => '2010-09-22T00:00:00',
        :max_amount_per_payment => '10',
        :max_number_of_payments => '10',
        :max_number_of_payments_per_period => '10',
        :max_total_amount_of_all_payments => '100',
        :payment_period => 'DAILY',
        :return_url => 'http://example.com/return',
        :starting_date => '2010-09-22T00:00:00',

        :request_envelope => {
          :detail_level => 'ReturnAll',
          :error_language => 'en_US'
        }
      }
    end

    let(:response_fixture) { 'preapproval_success' }

    subject { response }

    context "response envelope" do
      subject { response.response_envelope }

      its(:timestamp) { should == '2010-08-05T20:31:40.291-07:00' }
      its(:ack) { should == 'Success' }
      its(:correlation_id) { should == 'cca2fd6c44bd7' }
      its(:build) { should == '1437064' }
    end

    its(:preapproval_key) { should == 'PA-0P77054533508484A' }

    context "error" do
      it("is nil") { response.error.should be_nil }
    end
  end

  context "on failure" do
    let(:request_attributes) { {} }

    let(:response_fixture) { 'preapproval_failure' }

    subject { response }

    context "response envelope" do
      subject { response.response_envelope }

      its(:timestamp) { should == '2010-08-05T20:47:40.266-07:00' }
      its(:ack) { should == 'Failure' }
      its(:correlation_id) { should == '029e122e2f1d3' }
      its(:build) { should == '1437064' }
    end

    it('preapproval_key') { response.preapproval_key.should be_nil }

    context "error" do
      subject { response.error.first }

      its(:error_id) { should == '500000' }
      its(:domain) { should == 'PLATFORM' }
      its(:severity) { should == 'Error' }
      its(:category) { should == 'Application' }
      its(:message) { should == 'Internal Error' }
    end
  end
end
